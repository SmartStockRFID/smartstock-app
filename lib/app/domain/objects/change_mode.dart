abstract final class ChangeOperationModeObject {
    static const write = {
        'type': 'changeMode',
        'content': 'write',
    };

    static const read = {
        'type': 'changeMode',
        'content': 'stop',
    };
}