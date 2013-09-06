require 'ruby_kml'

kml = KMLFile.new

folder = KML::Folder.new(name: 'Apollo 12 Moon Landing')

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
	}
]

frames.each do |frame|
	puts frame[:lat]
	folder.features << KML::Placemark.new(
		name: frame[:name],
		geometry: KML::Point.new(coordinates: { lat: frame[:lat], lng: frame[:lng] })
	)	
end	

kml.objects << folder
puts kml.render
