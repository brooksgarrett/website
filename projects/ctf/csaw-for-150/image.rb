require 'chunky_png'

# First get a mask of the image to extract as much as possible.
$image = ChunkyPNG::Image.from_file('wet_QR.png')
$newImg = $image.extract_mask(bg_color=ChunkyPNG::Color::BLACK, 2391707391, tolerance=5)
$newImg[1].save('new2.png')

# Darken the image by marking any transition as a black pixel.
$image = ChunkyPNG::Image.from_file('new2.png')
$y = 0
  while $y < $image.dimension.height do
  $x = 0
    while $x < $image.dimension.width do
      if ($image.get_pixel($x, $y) > $image.get_pixel($x-1, $y))
        $image.set_pixel($x, $y, ChunkyPNG::Color::BLACK)
      end
    $x += 1
   end
 $y += 1
end
$image.save('newEdge.png')

=begin
# Trial and error lead to a tolerance of 25-28 as ideal.
# This code will find the pixels darker than dingy white and make them black.
$threshold = 25
while $threshold < 28 do
        $image = ChunkyPNG::Image.from_file('new2.png')
        $y = 0
        while $y < $image.dimension.height do
          $x = 0
          while $x < $image.dimension.width do
                if ($image.get_pixel($x, $y) > $threshold)
                          $image.set_pixel($x, $y, ChunkyPNG::Color::BLACK)
                        end
                $x += 1
          end
          $y += 1
        end
        $image.save("new#{$threshold}.png")
        $threshold += 1
end

# Same algo but against the edge detection instead of the mask.
$threshold = 25
while $threshold < 28 do
        $image = ChunkyPNG::Image.from_file('newEdge.png')
        $y = 0
        while $y < $image.dimension.height do
          $x = 0
          while $x < $image.dimension.width do
                if ($image.get_pixel($x, $y) > $threshold)
                          $image.set_pixel($x, $y, ChunkyPNG::Color::BLACK)
                        end
                $x += 1
          end
          $y += 1
        end
        $image.save("newEdge#{$threshold}.png")
        $threshold += 1
end
=end

# This is the correct one.
# The bottom half of the damn code is inverted.
# sdslabs.co.in is the key (need to md5 it)
# b149a901f5ca408a81fe8f36f7c717f6
$threshold = 26
$split = $image.height / 2
$image = ChunkyPNG::Image.from_file('newEdge.png')
$y = 0
while $y < $image.dimension.height do
  $x = 0
  while $x < $image.dimension.width do
    if ($y < $split)
		if ($image.get_pixel($x, $y) > $threshold)
		  $image.set_pixel($x, $y, ChunkyPNG::Color::BLACK)
                else
		  $image.set_pixel($x, $y, ChunkyPNG::Color::WHITE)
		end
	else
	    if ($image.get_pixel($x, $y) > $threshold)
			$image.set_pixel($x, $y, ChunkyPNG::Color::WHITE)
		else
		    $image.set_pixel($x, $y, ChunkyPNG::Color::BLACK)
		end
    end 
	$x += 1
  end
  $y += 1
end
$image.save("newInverse.png")

# Generate a friendly index to see all images at once.
File.open('index.html', 'w') { |file|
  file.write("<html><head /><body>")
  file.write("<h1>0riginal</h1>")
  file.write("<img src=\"wet_QR.png\" /> <br /><hr /><br />")
  file.write("<h1>Mask</h1>")
  file.write("<img src=\"new2.png\" /> <br /><hr /><br />")
  file.write("<h1>Edge</h1>")
  file.write("<img src=\"newEdge.png\" /> <br /><hr /><br />")
  file.write("<h1>Inverse</h1>")
  file.write("<img src=\"newInverse.png\" /> <br /><hr /><br />")
=begin
  $i = 25
  while $i < 28 do
    file.write("<h1>EdgeT = #{$i}</h1>")
    file.write("<img src=\"newEdge#{$i}.png\" /> <br /><hr /><br />")
        $i += 1
  end
  
  $i = 25
  while $i < 28 do
    file.write("<h1>T = #{$i}</h1>")
    file.write("<img src=\"new#{$i}.png\" /> <br /><hr /><br />")
        $i += 1
  end
=end
  file.write("</body></html>")
}

