require 'ruby_kml'

kml = KMLFile.new
kml.target = 'moon'

folder = KML::Folder.new(name: 'Apollo 12 Moon Landing')
tour = KML::Tour.new(name: 'Landing Tour', description: "Andy's attempt at recreating the Apollo 12 Moon Landing within Google Earth")

frames = [
	{
		name: 'Frame 2497',
		lng: -23.46138376727904,
		lat: -3.024139365484832,
		alt: 55.16999999891912,
		head: -112.1842470470624,
		tilt: 30.08006766232498,
		roll: 50
	},
	{
		name: 'Frame 2569',
		lng: -23.46138376727904,
		lat: -3.024139365484832,
		alt: 55.16999999891912,
		head: -112.1842470470624,
		tilt: 30.08006766232498,
		roll: 5
	},
  {
    name: 'Frame 2569',
    lng: -23.46138376727904,
    lat: -3.024139365484832,
    alt: 55.16999999891912,
    head: -112.1842470470624,
    tilt: 30.08006766232498,
    roll: 25
  },
  {
    name: 'Frame 2569',
    lng: -23.46138376727904,
    lat: -3.024139365484832,
    alt: 55.16999999891912,
    head: -112.1842470470624,
    tilt: 30.08006766232498,
    roll: 75
  }
]

frames.each do |frame|
  camera = KML::Camera.new(latitude: frame[:lat], longitude: frame[:lng], altitude: frame[:alt], heading: frame[:head], tilt: frame[:tilt], roll: frame[:roll], altitude_mode: 'relativeToSeaFloor')
  fly_to = KML::FlyTo.new(duration: 1, feature: camera)

  tour.features << fly_to
end


#frames.each do |frame|
#	puts frame[:lat]
#	folder.features << KML::Placemark.new(
#		name: frame[:name],
#		geometry: KML::Point.new(coordinates: { lat: frame[:lat], lng: frame[:lng] })
#	)
#end

kml.objects << folder
folder.features << tour
puts kml.render

kml.save('test.kml')
