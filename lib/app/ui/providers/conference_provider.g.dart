// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConferenceManager)
const conferenceManagerProvider = ConferenceManagerProvider._();

final class ConferenceManagerProvider
    extends $NotifierProvider<ConferenceManager, ConferenceManagerState> {
  const ConferenceManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conferenceManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conferenceManagerHash();

  @$internal
  @override
  ConferenceManager create() => ConferenceManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConferenceManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConferenceManagerState>(value),
    );
  }
}

String _$conferenceManagerHash() => r'53f769c449fce34dbcdea6820344a5cbc4b2bdf2';

abstract class _$ConferenceManager extends $Notifier<ConferenceManagerState> {
  ConferenceManagerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ConferenceManagerState, ConferenceManagerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConferenceManagerState, ConferenceManagerState>,
              ConferenceManagerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
