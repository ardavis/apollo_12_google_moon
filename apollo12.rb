require 'ruby_kml'

kml = KMLFile.new
kml.target = 'moon'

document = KML::Document.new(name: 'Apollo 12')
folder = KML::Folder.new(name: 'Apollo 12 Moon Landing')
placemarks_folder = KML::Folder.new(name: 'Placemarks Folder')
photo_overlays_folder = KML::Folder.new(name: 'Photo Overlays Folder')
tour = KML::Tour.new(name: 'Landing Tour', description: "Andy's attempt at recreating the Apollo 12 Moon Landing within Google Earth")

frames = [
  # Frame,       Lat,         Lng,       Alt,  Heading,   Tilt,    Roll
  ['2569', -3.024591901, -23.461139708, 35.02,  281.62,   40.98,   35.93],
  ['2497', -3.024025840, -23.460205460, 58.34,  273.17,   33.92,   14.64],
  ['2401', -3.023936246, -23.458817459, 67.57,  288.18,   36.23,   28.43],
  ['2305', -3.022876196, -23.457730169, 99.76,  271.28,   27.60,   4.53],
  ['2185', -3.024743586, -23.455781784, 105.01, 293.94,   56.71,   17.15],
  ['1993', -3.029869044, -23.449699344, 110.86, 304.98,   58.17,   45.65],
  ['1849', -3.030199454, -23.435975272, 157.18, 276.39,   60.81,   37.69]
]

frames.reverse.each do |name, lat, lng, alt, head, tilt, roll|
  camera = KML::Camera.new(latitude: lat, longitude: lng, altitude: alt, heading: head, tilt: tilt, roll: roll, altitude_mode: 'relativeToSeaFloor')

  fly_to = KML::FlyTo.new(duration: 2, fly_to_mode: 'smooth', feature: camera)
  placemark = KML::Placemark.new(name: "Frame #{name}")
  placemark.geometry = camera
  placemarks_folder.features << placemark

  photo_overlay = KML::PhotoOverlay.new(name: "Frame #{name}")
  photo_overlay.features << camera
  icon_style = KML::IconStyle.new(icon: KML::Icon.new(href: ':/camera_mode.png'))
  style = KML::Style.new
  style.icon_style = icon_style

  photo_overlay.features << style
  photo_overlay.features << KML::Icon.new(href: "Images/img0#{name}.png")

  photo_overlays_folder.features << photo_overlay

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
document.features << photo_overlays_folder
document.features << tour


kml.objects << document
puts kml.render

kml.save('test.kml')
