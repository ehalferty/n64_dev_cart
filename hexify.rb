File.open(ARGV[1], "w") do |of|
    File.open(ARGV[0], "rb") do |f|
        while (buffer = f.read(2)) do
            of.write(buffer.unpack("H*")[0] + "\n")
        end
    end
end
# ruby hexify.rb ~/n64/OneDrive-2022-03-06/PAMELA-BIGENDIAN.z64 ~/n64/OneDrive-2022-03-06/PAMELA-BIGENDIAN.hex.txt
# ruby hexify.rb ~/n64/OneDrive-2022-03-06/PAMELA-LITTLEENDIAN.n64 ~/n64/OneDrive-2022-03-06/PAMELA-LITTLEENDIAN.hex.txt
# ruby hexify.rb ~/n64/OneDrive-2022-03-06/PAMELA-BYTESWAPPED.v64 ~/n64/OneDrive-2022-03-06/PAMELA-BYTESWAPPED.hex.txt
