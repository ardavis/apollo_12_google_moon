require 'ruby_kml'

kml = KMLFile.new
kml.target = 'moon'

document = KML::Document.new(name: 'Apollo 12')
folder = KML::Folder.new(name: 'Apollo 12 Moon Landing')
placemarks_folder = KML::Folder.new(name: 'Placemarks Folder')
tour = KML::Tour.new(name: 'Landing Tour', description: "Andy's attempt at recreating the Apollo 12 Moon Landing within Google Earth")

frames = [
    #  Name,           Lat,         Lng,       Alt,  Heading,   Tilt,   Roll
  ['Frame 2569', -3.024085464, -23.461319052, 46.24, -112.18,   30.08,   0],
  ['Frame 2497', -3.023683398, -23.459995169, 76.15,  256.91,   30.08,   0],
  ['Frame 2401', -3.023148021, -23.458976309, 75.96,  256.91,   30.08,   0],
  ['Frame 2305', -3.022702344, -23.457850972, 111.67, 263.98,   23.70,   0],
  ['Frame 2185', -3.023911418, -23.455542650, 110.52, 284.18,   57.57,   14.57],
  ['Frame 1993', -3.028154330, -23.445872472, 183.33, 279.48,   57.57,   0],
  ['Frame 1849', -3.030133810, -23.436106469, 144.86, 275.20,   63.48,   0]
]

frames.each do |name, lat, lng, alt, head, tilt, roll|
  camera = KML::Camera.new(latitude: lat, longitude: lng, altitude: alt, heading: head, tilt: tilt, roll: roll, altitude_mode: 'relativeToSeaFloor')

  fly_to = KML::FlyTo.new(duration: 2, feature: camera)
  placemark = KML::Placemark.new(name: name)
  placemark.geometry = camera
  placemarks_folder.features << placemark

  tour.features << fly_to
end


#frames.each do |frame|
#	puts frame[:lat]
#	folder.features << KML::Placemark.new(
#		name: frame[:name],
#		geometry: KML::Point.new(coordinates: { lat: frame[:lat], lng: frame[:lng] })
#	)
#end

document.features << placemarks_folder
document.features << tour


kml.objects << document
puts kml.render

kml.save('test.kml')
