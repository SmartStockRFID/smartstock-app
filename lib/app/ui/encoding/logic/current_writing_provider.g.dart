// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_writing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WritingManager)
const writingManagerProvider = WritingManagerProvider._();

final class WritingManagerProvider
    extends $NotifierProvider<WritingManager, WritingManagerState> {
  const WritingManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writingManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writingManagerHash();

  @$internal
  @override
  WritingManager create() => WritingManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WritingManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WritingManagerState>(value),
    );
  }
}

String _$writingManagerHash() => r'49ffdc03fa7db2d8cbac73eff530380d460c3ee1';

abstract class _$WritingManager extends $Notifier<WritingManagerState> {
  WritingManagerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WritingManagerState, WritingManagerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WritingManagerState, WritingManagerState>,
              WritingManagerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
