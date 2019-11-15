# Black hole simulator

As the title says, this is a physics simulator designed for interaction between objects and black holes.
The simulation will handle moving objects interacting with a black hole and gravitational 'lensing' caused
around black holes.

## Interface

The interface is a resizable window, the bottom 24 (?) pixels reserved for text. The majority of the
screen is a rendering area, where the camera dumps its output. The camera can render in two different ways:

1. Draw a quick raster to the screen highlighting each object in the field of view. No light-bending will
occur.
2. Trace beams of light from the camera until they go off the map or hit an object. These beams are affected
by black holes.

The two rows at the moddom of the screen used for text are used resprctively for a result and a current
command input. There are commands to move the camera, to add a body (black hole or otherwise) to the scene, to
change the rendering mode, and to alter the state of the physics simulation. The physics simulation can be set
to run in real-time, which is only valid when the rendering mode is `raster`, or to step forward.

## Physics

The physics simulation is based on Newton's law of gravitation:

![Law of gravitation](http://www.sciweavers.org/tex2img.php?eq=F%3DG%5Cfrac%7Bm_1m_2%7D%7Br%5E2%7D&bc=White&fc=Black&im=png&fs=12&ff=arev&edit=0)

but modified a bit to get the force for a specific body, it looks like this:

![Modified Law, 1](http://www.sciweavers.org/tex2img.php?eq=F_1%3DG%5Cfrac%7Bm_1m_2%7D%7Br%5E2%7D%5Cdiv%5Cfrac%7Bm_1%7D%7Bm_1%2Bm_2%7D&bc=White&fc=Black&im=png&fs=12&ff=arev&edit=0)

![Modified law, 2](http://www.sciweavers.org/tex2img.php?eq=F_1%3DG%5Cfrac%7B%28m_1%29%5E2%5Ctimes%20m_2%2Bm_1%5Ctimes%28m_2%29%5E2%7D%7Bm_1%5Ctimes%20r%5E2%7D&bc=White&fc=Black&im=png&fs=12&ff=arev&edit=0)

This force is used, along with the direction of the black hole from the body, to modify the body's internal
direction vector, which changes the position each tick.

## Licensing

The Source Code Pro TrueType font is licensed under the Open font License, available on Adobe's repository

[Adobe-Fonts/source-code-pro](https://github.com/adobe-fonts/source-code-pro/)
