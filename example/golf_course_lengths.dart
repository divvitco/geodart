import 'dart:convert';

import 'package:geodart/conversions.dart';
import 'package:geodart/geometries.dart';

/// downloaded from https://hub.arcgis.com/datasets/7b5c7948792a4593a5c9f757bd0deaa3/explore?location=37.640272%2C-118.981760%2C16.69
String golfCourseHolesSource = '''
{
"type": "FeatureCollection",
"name": "Golf_Course_Holes",
"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
"features": [
{ "type": "Feature", "properties": { "OBJECTID": 1, "HoleNum": 1, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{7B508109-42C0-4789-815B-2ED6E879B370}" }, "geometry": { "type": "Point", "coordinates": [ -118.984167640242262, 37.639748768658407 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 2, "HoleNum": 1, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{9F286606-9D85-44B7-9D2C-8E41776B3D4E}" }, "geometry": { "type": "Point", "coordinates": [ -118.984632991330145, 37.637136878019021 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 3, "HoleNum": 2, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{ED714B59-9CFF-4FF2-8C92-F2AFE3A5F2D5}" }, "geometry": { "type": "Point", "coordinates": [ -118.98502426929501, 37.637125107717502 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 4, "HoleNum": 2, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{976BB7EC-85A9-4720-8E55-8FE66C6D1AC6}" }, "geometry": { "type": "Point", "coordinates": [ -118.985874206481228, 37.637682313837587 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 5, "HoleNum": 3, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{0808C252-C057-433A-A12D-245719AF5248}" }, "geometry": { "type": "Point", "coordinates": [ -118.985097418300526, 37.637684939571145 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 6, "HoleNum": 3, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{F2BCA001-CA58-42DC-B48D-597E37B316BF}" }, "geometry": { "type": "Point", "coordinates": [ -118.98436367033139, 37.640822969068829 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 7, "HoleNum": 4, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{09E900AD-3D1C-4D9F-A082-F4C68190E2CE}" }, "geometry": { "type": "Point", "coordinates": [ -118.985629182921983, 37.640177427255168 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 8, "HoleNum": 4, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{1A368A1E-5D92-4748-8FE4-CA4405969968}" }, "geometry": { "type": "Point", "coordinates": [ -118.986073228150474, 37.643479665867027 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 9, "HoleNum": 5, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{7F7D572B-28B0-4277-B6B0-2BD19C95BCC7}" }, "geometry": { "type": "Point", "coordinates": [ -118.985773858954971, 37.643973770624399 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 10, "HoleNum": 5, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{A22CC18A-1318-4625-8F94-CD4A1AB44246}" }, "geometry": { "type": "Point", "coordinates": [ -118.982510428981058, 37.642690015549512 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 11, "HoleNum": 6, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{61ECC5C5-6428-419D-A3AA-F2362066F5ED}" }, "geometry": { "type": "Point", "coordinates": [ -118.981749690697242, 37.643650870780014 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 12, "HoleNum": 6, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{86141511-CFF7-4382-A134-EBB9B1CE59F1}" }, "geometry": { "type": "Point", "coordinates": [ -118.982000091358785, 37.646919124793193 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 13, "HoleNum": 7, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{680B0196-802E-4B8A-911C-DE9DC2CB5F9B}" }, "geometry": { "type": "Point", "coordinates": [ -118.981490375347676, 37.647035451664422 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 14, "HoleNum": 7, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{CE3CBB8F-7142-4B92-916A-1AC763E96C97}" }, "geometry": { "type": "Point", "coordinates": [ -118.979476604790122, 37.646855023511414 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 15, "HoleNum": 8, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{55EEF706-D904-4FE0-A031-A8539FFF565C}" }, "geometry": { "type": "Point", "coordinates": [ -118.978606954321478, 37.646935184963283 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 16, "HoleNum": 8, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{38936A7A-15A8-4663-8BAC-A4735F6F5332}" }, "geometry": { "type": "Point", "coordinates": [ -118.979933959458918, 37.642899419448398 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 17, "HoleNum": 9, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{76516928-EB6E-46F7-AD3F-E66B2B8CE931}" }, "geometry": { "type": "Point", "coordinates": [ -118.978467120308679, 37.645827184233291 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 18, "HoleNum": 9, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{8A9C7D8F-FFA1-4822-81E1-91408C2C4889}" }, "geometry": { "type": "Point", "coordinates": [ -118.979490209523618, 37.643085938658565 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 19, "HoleNum": 10, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{A851C6CA-3F97-44DC-ACB3-67370B9FDBE4}" }, "geometry": { "type": "Point", "coordinates": [ -118.978126465559356, 37.645041192384468 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 20, "HoleNum": 10, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{0D93F76F-AB53-4EB6-AC1B-CE921C584904}" }, "geometry": { "type": "Point", "coordinates": [ -118.978847706265242, 37.640587918051452 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 21, "HoleNum": 11, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{4F1CB98D-269C-4E69-9734-17183D93FD8D}" }, "geometry": { "type": "Point", "coordinates": [ -118.977611188275276, 37.639812908703398 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 22, "HoleNum": 14, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{AB2DA73B-92B6-4F27-BD89-542FF5BB82A0}" }, "geometry": { "type": "Point", "coordinates": [ -118.978753162510401, 37.639525144901214 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 23, "HoleNum": 14, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{7FC7A355-2442-4135-87F7-9F5ECBFF5C6C}" }, "geometry": { "type": "Point", "coordinates": [ -118.977428044279392, 37.63894911525648 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 24, "HoleNum": 13, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{0D6CF6AC-C62F-4E61-905D-309D23DAD6ED}" }, "geometry": { "type": "Point", "coordinates": [ -118.977397987408992, 37.638352032563994 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 25, "HoleNum": 11, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{974737BB-B76D-4D92-AA60-51FD16C221C8}" }, "geometry": { "type": "Point", "coordinates": [ -118.974030451954391, 37.639716125319566 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 26, "HoleNum": 12, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{868FA981-72B5-46FD-B8A5-46B0F929B08C}" }, "geometry": { "type": "Point", "coordinates": [ -118.973398546045388, 37.639867599809058 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 27, "HoleNum": 12, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{92263DD7-00E1-41EA-91AF-C8B6E759E745}" }, "geometry": { "type": "Point", "coordinates": [ -118.973762963345891, 37.63730065594995 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 28, "HoleNum": 13, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{67000D0C-F395-4B2B-8BC1-7D812F9CDECA}" }, "geometry": { "type": "Point", "coordinates": [ -118.97411514117988, 37.637132929177007 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 29, "HoleNum": 15, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{E12A35F1-96A6-44E0-A859-10EED800ABEC}" }, "geometry": { "type": "Point", "coordinates": [ -118.979439681558418, 37.640580335475775 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 30, "HoleNum": 16, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{601D60B2-EA00-4572-846F-420009ADABC5}" }, "geometry": { "type": "Point", "coordinates": [ -118.980874861607433, 37.643015053685126 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 31, "HoleNum": 16, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{82D177CF-85FB-4026-A0A0-84D7457ADD53}" }, "geometry": { "type": "Point", "coordinates": [ -118.98172278008515, 37.642315332981909 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 32, "HoleNum": 16, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{6BBE8837-063C-4B8D-90EF-A032B7AB4ADA}" }, "geometry": { "type": "Point", "coordinates": [ -118.981662140566527, 37.63907159863907 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 33, "HoleNum": 17, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{AE7EEA80-3A1A-4FC5-AAB7-5BFE4313CEA1}" }, "geometry": { "type": "Point", "coordinates": [ -118.981690286326682, 37.638274600491449 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 34, "HoleNum": 17, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{4ED80A82-B7C5-4486-AD49-90EA88665CFA}" }, "geometry": { "type": "Point", "coordinates": [ -118.98417748999735, 37.637142711914436 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 35, "HoleNum": 18, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{8EA8E37C-0252-4ECA-B76B-E4D58BF22B88}" }, "geometry": { "type": "Point", "coordinates": [ -118.984076403718205, 37.637479673864696 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 36, "HoleNum": 18, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{E694822C-9EE8-4F4C-A798-CD61D87CFB8C}" }, "geometry": { "type": "Point", "coordinates": [ -118.983637422166581, 37.639185296667726 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 37, "HoleNum": 1, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{1EE4E2D7-1144-4D55-84E6-D939FD408A25}" }, "geometry": { "type": "Point", "coordinates": [ -118.973118036930686, 37.631199470114218 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 38, "HoleNum": 1, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{55CE4955-9A67-4C0B-A597-3650A0109DC2}" }, "geometry": { "type": "Point", "coordinates": [ -118.974699546456449, 37.626681654865742 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 39, "HoleNum": 2, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{A9D3B1F2-85CA-45EC-9744-FBD92361EEEC}" }, "geometry": { "type": "Point", "coordinates": [ -118.974903547770396, 37.626369930495706 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 40, "HoleNum": 2, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{0558CF7A-794A-45ED-9174-092DABD226CB}" }, "geometry": { "type": "Point", "coordinates": [ -118.977858022241804, 37.623851863388943 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 41, "HoleNum": 3, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{A95C815F-BDDF-4280-927A-1E434C4A7635}" }, "geometry": { "type": "Point", "coordinates": [ -118.977353602464959, 37.623683460221265 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 42, "HoleNum": 3, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{1C3EBA06-E08F-4BE4-9AD7-121D6E816FF6}" }, "geometry": { "type": "Point", "coordinates": [ -118.978968502825438, 37.622627629586951 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 43, "HoleNum": 4, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{1D7DB408-497F-4DEC-8288-E1BD490E5429}" }, "geometry": { "type": "Point", "coordinates": [ -118.978586595622019, 37.622206796002921 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 44, "HoleNum": 4, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{2536D329-A2F2-4707-AF80-FBC5A3B8AA37}" }, "geometry": { "type": "Point", "coordinates": [ -118.982120542336446, 37.622467715826424 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 45, "HoleNum": 5, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{8DC4C0C9-8261-4E3B-A3D6-5F1ABDF1F186}" }, "geometry": { "type": "Point", "coordinates": [ -118.98208834641666, 37.62295333342847 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 46, "HoleNum": 5, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{2CDA4BB2-2989-4CAE-8EBB-430E138026AB}" }, "geometry": { "type": "Point", "coordinates": [ -118.978772255166461, 37.62340564698524 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 47, "HoleNum": 6, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{3DA59842-8CD9-4C18-9126-F0FE86A0FE6B}" }, "geometry": { "type": "Point", "coordinates": [ -118.979482815798349, 37.623771121882861 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 48, "HoleNum": 6, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{27429B7E-EB56-44C0-A461-43FC0010DE8F}" }, "geometry": { "type": "Point", "coordinates": [ -118.976323505503331, 37.626161242954915 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 49, "HoleNum": 7, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{B367DD99-4292-4287-BE81-7C8CCA00E4A5}" }, "geometry": { "type": "Point", "coordinates": [ -118.976956845917073, 37.626402311471281 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 50, "HoleNum": 7, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{CD5C1520-66B5-45B7-A843-420FEDA4D462}" }, "geometry": { "type": "Point", "coordinates": [ -118.975365594204021, 37.626614569868352 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 51, "HoleNum": 8, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{D3E6A6E5-89F3-4083-8341-4516BA394B80}" }, "geometry": { "type": "Point", "coordinates": [ -118.97546077868796, 37.627095962768585 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 52, "HoleNum": 8, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{E2A81148-A5D6-495F-9A63-98AD36135798}" }, "geometry": { "type": "Point", "coordinates": [ -118.974331522619536, 37.630122875950278 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 53, "HoleNum": 9, "TeeHole": "Tee", "last_edited_date": null, "GlobalID": "{117B1316-FCCA-469A-A908-0796D02D47DB}" }, "geometry": { "type": "Point", "coordinates": [ -118.974533274815073, 37.630403183119952 ] } },
{ "type": "Feature", "properties": { "OBJECTID": 54, "HoleNum": 9, "TeeHole": "Hole", "last_edited_date": null, "GlobalID": "{5F7BAFD6-4888-4EE9-A840-85E29FD894B8}" }, "geometry": { "type": "Point", "coordinates": [ -118.971949951934775, 37.632368559910581 ] } }
]
}
''';

void main() {
  final featureJson = json.decode(golfCourseHolesSource);
  FeatureCollection featureCollection = FeatureCollection.fromJson(featureJson);

  print(
      "This golf course is about ${convertArea(featureCollection.convexHull.area, AreaUnits.squareMeters, AreaUnits.acres).toStringAsFixed(2)} acres in size.");

  for (int i = 1; i <= 9; i++) {
    final tee = featureCollection.features.firstWhere((f) =>
        f.properties['HoleNum'] == i && f.properties['TeeHole'] == 'Tee');
    final hole = featureCollection.features.firstWhere((f) =>
        f.properties['HoleNum'] == i && f.properties['TeeHole'] == 'Hole');

    final teePoint = tee as Point;
    final holePoint = hole as Point;

    LineString holeLine =
        LineString([teePoint.coordinate, holePoint.coordinate]);

    Point driverDistance = holeLine
        .along(convertDistance(250, DistanceUnits.yards, DistanceUnits.meters));

    double percentage = 100.0 *
        driverDistance.coordinate.distanceTo(teePoint.coordinate) /
        holeLine.length;

    print(
        'Hole $i: ${convertDistance(holeLine.length, DistanceUnits.meters, DistanceUnits.yards).toStringAsFixed(2)}yds - you\'ll probably hit it ${percentage.round()}% of the way there with your driver.');
  }
}
