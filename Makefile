BUILD_FLAGS := -DBUILD_COMMIT="\"`git rev-parse --short HEAD``git diff --shortstat --quiet || echo ' (dirty)'`\"" -DBUILD_DATE="\"`date -u +'%Y-%m-%d %H:%M:%S %Z'`\""

all:
	mkdir -p bin
	g++ -o bin/decodepng decodepng.cpp lodepng/lodepng.cpp $(BUILD_FLAGS)

armhf:
	mkdir -p bin
	arm-linux-gnueabihf-g++ -o bin/decodepng-armhf decodepng.cpp lodepng/lodepng.cpp $(BUILD_FLAGS)

clean:
	rm -r bin