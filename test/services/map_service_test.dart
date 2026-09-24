import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/services/map_service.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:mocktail/mocktail.dart';

class MockMaplibreMapController extends Mock implements MaplibreMapController {}

class FakeCameraUpdate extends Fake implements CameraUpdate {}

class FakeCircleLayerProperties extends Fake implements CircleLayerProperties {}

void main() {
  late MapService mapService;
  late MockMaplibreMapController mockController;

  setUpAll(() {
    registerFallbackValue(FakeCameraUpdate());
    registerFallbackValue(const CircleLayerProperties());
  });

  setUp(() {
    mapService = MapService();
    mockController = MockMaplibreMapController();
  });

  test('setController correctly sets the controller', () {
    mapService.setController(mockController);
    expect(mapService.controller, equals(mockController));
  });

  test('loadGeoJsonLayer returns early without error if controller is null',
      () async {
    await mapService.loadGeoJsonLayer({
      'type': 'FeatureCollection',
      'features': [],
    });
    expect(mapService.controller, isNull);
  });

  test('updateUserLocationMarker executes correctly when controller is set',
      () async {
    mapService.setController(mockController);

    when(() => mockController.removeLayer(any())).thenAnswer((_) async => true);
    when(() => mockController.removeSource(any()))
        .thenAnswer((_) async => true);
    when(() => mockController.addGeoJsonSource(any(), any()))
        .thenAnswer((_) async => true);
    when(() => mockController.addCircleLayer(any(), any(), any()))
        .thenAnswer((_) async => true);

    await mapService
        .updateUserLocationMarker(const LatLng(-7.797068, 110.370529));

    verify(() => mockController.addGeoJsonSource(any(), any())).called(1);
    verify(() => mockController.addCircleLayer(any(), any(), any())).called(1);
  });

  test('animateToLocation animates camera when controller is set', () async {
    mapService.setController(mockController);

    when(() => mockController.animateCamera(any<CameraUpdate>()))
        .thenAnswer((_) async => true);

    await mapService.animateToLocation(const LatLng(-7.797068, 110.370529));

    verify(() => mockController.animateCamera(any<CameraUpdate>())).called(1);
  });
}
