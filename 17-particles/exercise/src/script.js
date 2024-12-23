import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import { Timer } from 'three/addons/misc/Timer.js';
import GUI from 'lil-gui';

/**
 * Base
 */
// Debug
const gui = new GUI();

// Canvas
const canvas = document.querySelector('canvas.webgl');

// Scene
const scene = new THREE.Scene();

/**
 * Textures
 */
// Geometry
const textureLoader = new THREE.TextureLoader();
const particlesTexture = textureLoader.load('/textures/particles/4.png');

// Material
const particlesGeometry = new THREE.BufferGeometry();

const count = 20000;
const positionsArray = new Float32Array(count * 3);
const colorsArray = new Float32Array(count * 3);

for(let i = 0; i < count * 3; i++) {
    positionsArray[i] = (Math.random() - 0.5) * 10;
    colorsArray[i] = Math.random();
}

particlesGeometry.setAttribute('position', new THREE.BufferAttribute(positionsArray, 3));
particlesGeometry.setAttribute('color', new THREE.BufferAttribute(colorsArray, 3));

const particlesMaterial = new THREE.PointsMaterial({
    // color: 0xff88cc,
    size: 0.1,
    sizeAttenuation: true,
    map: particlesTexture,
    transparent: true,
    alphaMap: particlesTexture,
    // alphaTest: 0.001
    // depthTest: false,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    vertexColors: true
});

// Points
const particles = new THREE.Points(particlesGeometry, particlesMaterial);
scene.add(particles);

/**
 * Test cube
 */
const cube = new THREE.Mesh(
    new THREE.BoxGeometry(1, 1, 1),
    new THREE.MeshBasicMaterial()
);
// scene.add(cube);

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
};

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth;
    sizes.height = window.innerHeight;

    // Update camera
    camera.aspect = sizes.width / sizes.height;
    camera.updateProjectionMatrix();

    // Update renderer
    renderer.setSize(sizes.width, sizes.height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100);
camera.position.z = 3;
scene.add(camera);

// Controls
const controls = new OrbitControls(camera, canvas);
controls.enableDamping = true;

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas
});
renderer.setSize(sizes.width, sizes.height);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

/**
 * Animate
 */
const timer = new Timer();

const tick = () =>
{
    timer.update();
    const elapsedTime = timer.getElapsed();

    // Update particles
    // particles.position.y = -elapsedTime / 10;

    // Bad practice, the ideal way to animate is using a custom shader
    for (let i = 0; i < count; i++) {
        const i3 = i * 3;
        const x = particlesGeometry.attributes.position.array[i3];
        particlesGeometry.attributes.position.array[i3 + 1] = Math.sin(elapsedTime + x);
        particlesGeometry.attributes.position.needsUpdate = true;
    }

    // Update controls
    controls.update();

    // Render
    renderer.render(scene, camera);

    // Call tick again on the next frame
    window.requestAnimationFrame(tick);
};

tick();