import 'dart:io';

const envDirectoryPath = './env';

Map<String, String> readEnv(String path) {
  final file = File(path);

  if (!file.existsSync()) {
    return {};
  }

  return Map.fromEntries(
    file
        .readAsLinesSync()
        .where((line) {
      final trimmed = line.trim();
      return trimmed.isNotEmpty && !trimmed.startsWith('#');
    })
        .map((line) {
      final index = line.indexOf('=');

      if (index == -1) {
        return null;
      }

      return MapEntry(
        line.substring(0, index).trim(),
        line.substring(index + 1).trim(),
      );
    })
        .whereType<MapEntry<String, String>>(),
  );
}

void writeEnv(
    String filename,
    Map<String, String> variables, {
      required bool force,
    }) {
  final file = File(filename);
  final exists = file.existsSync();

  if (exists && !force) {
    print('Warning: skipped $filename — file already exists');
    return;
  }

  final content = variables.entries
      .map((e) => '${e.key}=${e.value}')
      .join('\n');

  file.writeAsStringSync('$content\n');

  print('${exists ? 'Updated' : 'Created'}: $filename');
}

void main(List<String> args) {
  final force = args.contains('--force');

  final envDirectory = Directory(envDirectoryPath);

  if (!envDirectory.existsSync()) {
    print('Warning: $envDirectoryPath does not exist');
    return;
  }

  final baseEnvPath = '$envDirectoryPath/.env';
  final baseEnv = readEnv(baseEnvPath);

  writeEnv(
    '.env',
    baseEnv,
    force: force,
  );

  final environmentFiles = envDirectory
      .listSync()
      .whereType<File>()
      .where((file) {
    final name = file.uri.pathSegments.last;
    return name.startsWith('.env.');
  });

  for (final file in environmentFiles) {
    final name = file.uri.pathSegments.last;
    final envValue = readEnv(file.path);

    final variables = {
      ...baseEnv,
      ...envValue,
    };

    writeEnv(
      name,
      variables,
      force: force,
    );
  }
}
