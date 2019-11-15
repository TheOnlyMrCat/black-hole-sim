module camera;

import std.conv;
import std.math;
import std.experimental.logger;

import cat.wheel.ecs;
import cat.wheel.events;
import cat.wheel.graphics;
import cat.wheel.structs;

import body;
import graphics;

/// Field of view of the camera, in radians
immutable(float) FOV = 2;
immutable(float) STEP = 0.1;
immutable(float) MAX = 3.1;

class Camera {

    this(Graphics g, Simulator s) {
        _graphics = g;
        _s = s;

        info("Created camera");
    }

    void render() {
        Body[] bodies = _s.bodies;

        for (int y = 0; y < 480; y++) {
            const(float) alpha = (3 * FOV / 2 / 4) * (y - 240) / 240;
            for (int x = 0; x < 640; x++) {
                const(float) beta = FOV / 2 * (x - 320) / 320;
                Color c = Color(0, 0, 0, 255);

            raycast:
                for (
                    Vector3F pos = _pos;
                    abs(pos.x) < MAX && abs(pos.y) < MAX && abs(pos.z) < MAX;
                    pos = Vector3F(pos.x + cos(alpha) * cos(beta) * STEP, pos.y + sin(alpha) * STEP, pos.z + sin(beta) * cos(alpha) * STEP)
                ) {
                    foreach (b; bodies) {
                        const(float) dist = abs(sqrt(pow(b.pos.x - pos.x, 2) + pow(b.pos.y - pos.y, 2) + pow(b.pos.z - pos.z, 2)));

                        if (dist <= b.radius) {
                            const float scale = (pos.x - b.pos.x) / b.radius / 2 + 1;
                            c = Color(((b.colour2.r - b.colour1.r) * scale).to!ubyte, ((b.colour2.g - b.colour1.g) * scale).to!ubyte, ((b.colour2.b - b.colour1.b) * scale).to!ubyte, ((b.colour2.a - b.colour1.a) * scale).to!ubyte);
                            break raycast;
                        }
                    }
                }

                _graphics.color = c;
                _graphics.drawPoint(Vector2(x, y));
            }
        }

        _graphics.render();
        _graphics.color = Color(0, 0, 0, 255);
        _graphics.clear();
    }

    auto position() {
        return _pos;
    }

    void setPosition(Vector3F pos) {
        _pos = pos;
    }

    auto rotation() {
        return _rot;
    }

    void setRotation(Vector2F rot) {
        _rot = rot;
    }

private:
    Graphics _graphics;
    Simulator _s;

    bool _rendering;
    Vector3F _pos;
    Vector2F _rot;
}