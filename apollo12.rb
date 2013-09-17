require 'ruby_kml'

kml = KMLFile.new
kml.target = 'moon'

document = KML::Document.new(name: 'Apollo 12')
folder = KML::Folder.new(name: 'Apollo 12 Moon Landing')
placemarks_folder = KML::Folder.new(name: 'Placemarks Folder')
photo_overlays_folder = KML::Folder.new(name: 'Photo Overlays Folder')
tour = KML::Tour.new(name: 'Landing Tour', description: "Andy's attempt at recreating the Apollo 12 Moon Landing within Google Earth")

frames = [
  # Frame,       Lat           Lng       Alt     Heading  Tilt    Roll
  [2785, -3.024793921, -23.462411298, 14.96,   292.44,  43.89, 28.36],
  [2761, -3.024808710, -23.462401341, 15.80,   295.36,  44.04, 28.36],
  [2737, -3.024804113, -23.462370680, 17.07,   293.40,  43.10, 30.24],
  [2713, -3.024728636, -23.462287168, 18.62,   277.57,  43.21, 30.24],
  [2689, -3.024734539, -23.462108934, 19.12,   276.09,  44.21, 12.23],
  [2665, -3.024767949, -23.461992933, 23.84,   280.77,  38.97, 11.65],
  [2641, -3.024899912, -23.461950516, 28.68,   296.23,  34.61, 16.64],
  [2617, -3.024942280, -23.461781683, 31.71,   297.97,  35.23, 16.64],
  [2593, -3.024805511, -23.461473960, 38.66,   285.88,  33.79, 5.87],
  [2569, -3.024591901, -23.461139708, 35.02,   281.62,  40.98, 20.47],
  [2497, -3.024025840, -23.460205460, 58.34,   273.17,  33.92, 14.64],
  [2401, -3.023936246, -23.458817459, 67.57,   288.18,  36.23, 28.43],
  [2305, -3.022876196, -23.457730169, 99.76,   271.28,  27.60, 4.53],
  [2185, -3.024743586, -23.455781784, 105.01,  293.94,  56.71, 17.15],
  [1993, -3.029869044, -23.449699344, 110.86,  304.98,  58.17, 45.65],
  [1849, -3.030199454, -23.435975272, 157.18,  276.39,  60.81, 37.69],
  [1609, -3.041156197, -23.404769859, 296.23,  285.54,  56.33, 38.41],
  [1369, -3.052438132, -23.356321334, 694.83,  283.60,  59.81, 36.51],
  [1009, -3.079721051, -23.251851021, 1911.57, 286.97,  56.94, 38.49],
  [ 961, -3.071037948, -23.230941343, 1852.18, 286.17,  86.48, 32.60]
]
frames.reverse!
frames.each_with_index do |frame_info, i|
  frame, lat, lng, alt, head, tilt, roll = frame_info

  name = frame.to_s.rjust(5, '0')
  camera = KML::Camera.new(latitude: lat, longitude: lng, altitude: alt, heading: head, tilt: tilt, roll: roll, altitude_mode: 'relativeToSeaFloor')

  # (Next frame number - current frame number) / 24
  duration = if i < frames.count - 1
    (frames[i+1][0] - frames[i][0]) / 24 
  else
    1
  end
  fly_to = KML::FlyTo.new(duration: duration, fly_to_mode: 'smooth', feature: camera)
  placemark = KML::Placemark.new(name: "Frame #{name}")
  placemark.geometry = camera
  placemarks_folder.features << placemark

  photo_overlay = KML::PhotoOverlay.new(name: "Frame #{name}")
  photo_overlay.features << camera
  icon_style = KML::IconStyle.new(icon: KML::Icon.new(href: ':/camera_mode.png'))
  style = KML::Style.new
  style.icon_style = icon_style

  photo_overlay.features << style
  photo_overlay.features << KML::Icon.new(href: "Images/img#{name}.png")

  photo_overlays_folder.features << photo_overlay

  tour.features << fly_to
end

document.features << placemarks_folder
document.features << photo_overlays_folder
document.features << tour


kml.objects << document
puts kml.render

kml.save('test.kml')
