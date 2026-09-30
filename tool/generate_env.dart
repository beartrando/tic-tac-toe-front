import 'dart:io';

const base = {
  'ENV': 'dev',

// g8
// GATEWAY_HOST=192.168.31.175
// g3
'GATEWAY_HOST': "192.168.31.186",
'GATEWAY_PORT': "9090",

// g8
// STREAMING_HOST=192.168.31.175
// g3
'STREAMING_HOST': "192.168.31.186",
'STREAMING_PORT': "8080"


MOVE_TIMEOUT=20
};

const environments = {
  'dev': {
// GCE
    'GATEWAY_HOST': '34.158.224.195',
// s-host
// 'GATEWAY_HOST': "31.222.235.64",

// GCE
    'STREAMING_HOST': '34.116.223.174',
// s-host
// 'STREAMING_HOST': "31.222.235.64",
  },
  'uat': {
    'ENV': 'dev',
// GCE
    'GATEWAY_HOST': '34.158.224.195',
// s-host
// 'GATEWAY_HOST': "31.222.235.64",

// GCE
    'STREAMING_HOST': '34.116.223.174',
// s-host
// 'STREAMING_HOST': "31.222.235.64",
  },
  'prod': {
    'ENV': 'production',
// GCE
    'GATEWAY_HOST': '34.158.224.195',
// s-host
// 'GATEWAY_HOST': "31.222.235.64",

// GCE
    'STREAMING_HOST': '34.116.223.174',
// s-host
// 'STREAMING_HOST': "31.222.235.64",
  },
};

void writeEnv(String filename, Map<String, String> variables) {
  final content = variables.entries
      .map((e) => '${e.key}=${e.value}')
      .join('\n');

  File(filename).writeAsStringSync('$content\n');
}

void main() {
  writeEnv('.env', base);

  for (final entry in environments.entries) {
    final variables = {
      ...base,
      ...entry.value,
    };

    writeEnv('.env.${entry.key}', variables);
  }
}
