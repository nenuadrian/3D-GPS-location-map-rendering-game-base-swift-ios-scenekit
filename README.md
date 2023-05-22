# 3D iOS Map SceneKit Rendering App - Mapzen data


The project involves creating a custom Map rendering using SceneKit and MapBox data at zoom level 16.

Significant effort has been dedicated to ensuring a seamless user experience, particularly regarding touch-based camera rotation. The implementation restricts camera movement, preventing it from going underground or surpassing a certain height, while enabling a full 360-degree rotation around the player.

Due to the discontinuation of the Mapzen API, a transition to Mapbox is necessary, similar to the process undertaken in the following repository: https://github.com/nenuadrian/swift-2D-tile-real-world-map-gps-game

To achieve desired results, post-processing similar to the mentioned repository should be implemented, along with necessary code modifications. Notably, the advantage of this Swift-based project is its ability to accomplish what the PHP repository accomplishes.

# Setup

Make sure to set DEBUG to false in constants or you'll be stuck to one location
SHould work out of the box once the mapbox issue is resolved

# Guides

web-maps-cartography-guide.pdf guide attached, describing how maps generally work on the web and in apps

In case you don't already have a basic understanding of how GPS maps are tiled.

# Known issues

Very likely if you travel enough you'll hit rounding errors because of the coordinates. When you surpass a certain number of tile, the system should reset and select a new origin tile, by updating the so called primordialTile to be a new one the player is currently one, and redrawing everything relative to that, avoiding the rounding error.

There're are surely issues if you go around the globe (eg before first or after last tile in a row)

# Screenshots

![Screenshot](screens/s1.png)

![Screenshot](screens/s2.png)

![Screenshot](screens/s3.png)
