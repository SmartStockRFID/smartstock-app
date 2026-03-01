abstract final class ChangeOperationModeCommand {
  static const write = {'type': 'changeMode', 'content': 'write'};

  static const read = {'type': 'changeMode', 'content': 'stop'};
}
