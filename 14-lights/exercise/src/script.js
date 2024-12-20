import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import { RectAreaLightHelper } from 'three/examples/jsm/helpers/RectAreaLightHelper.js';
import GUI from 'lil-gui';

/**
 * Base
 */
// Debug
const gui = new GUI();
gui.close();
gui._closeFolders = true

// Canvas
const canvas = document.querySelector('canvas.webgl');

// Scene
const scene = new THREE.Scene();

/**
 * Lights
 */
// Ambient light
const ambientLight = new THREE.AmbientLight(0xffffff, 0);
scene.add(ambientLight);

const ambientLightTweaks = gui.addFolder('Ambient Light');

ambientLightTweaks
    .add(ambientLight, 'intensity')
    .min(0)
    .max(3)
    .step(0.01)
    .name('Intensity');

// Directional light
const directionalLight = new THREE.DirectionalLight(0x00fffc, 0.9);
directionalLight.position.set(1, 0.25, 0);
scene.add(directionalLight);

const dirLightTweaks = gui.addFolder('Directional Light');

dirLightTweaks
    .addColor(directionalLight, 'color')
    .name('Color');

dirLightTweaks
    .add(directionalLight, 'intensity')
    .min(0)
    .max(3)
    .step(0.01)
    .name('Intensity');

// Hemisphere light
const hemisphereLight = new THREE.HemisphereLight(0x0000ff, 0xff0000, 0.9);
scene.add(hemisphereLight);

const hemiLightTweaks = gui.addFolder('Hemisphere Light');

hemiLightTweaks
    .addColor(hemisphereLight, 'color')
    .name('Color 1');

hemiLightTweaks
    .addColor(hemisphereLight, 'groundColor')
    .name('Color 2');

hemiLightTweaks
    .add(hemisphereLight, 'intensity')
    .min(0)
    .max(3)
    .step(0.01)
    .name('Intensity');

// Point light
const pointLight = new THREE.PointLight(0xff9000, 1.5);
pointLight.position.set(1, -0.5, 1);
scene.add(pointLight);

const pointLightTweaks = gui.addFolder('Point Light');

pointLightTweaks
    .addColor(pointLight, 'color')
    .name('Color');

pointLightTweaks
    .add(pointLight, 'intensity')
    .min(0)
    .max(3)
    .step(0.01)
    .name('Intensity');

pointLightTweaks
    .add(pointLight, 'distance')
    .min(0.01)
    .max(2)
    .step(0.01)
    .name('Distance');

pointLightTweaks
    .add(pointLight, 'decay')
    .min(0)
    .max(10)
    .step(0.01)
    .name('Decay');

pointLightTweaks
    .add(pointLight.position, 'x')
    .min(-3)
    .max(3)
    .step(0.01)
    .name('X');

pointLightTweaks
    .add(pointLight.position, 'y')
    .min(-0.5)
    .max(0.5)
    .step(0.01)
    .name('Y');

pointLightTweaks
    .add(pointLight.position, 'z')
    .min(-3)
    .max(3)
    .step(0.01)
    .name('Z');

// RectArea light
const rectAreaLight = new THREE.RectAreaLight(0xd300ff, 6, 1, 1);
rectAreaLight.position.set(-1.5, 0, 1.5);
rectAreaLight.lookAt(new THREE.Vector3());
scene.add(rectAreaLight);

const rectAreaLightTweaks = gui.addFolder('RectArea Light');

rectAreaLightTweaks
    .addColor(rectAreaLight, 'color')
    .name('RectArea Light Color');

rectAreaLightTweaks
    .add(rectAreaLight, 'intensity')
    .min(0)
    .max(10)
    .step(0.01)
    .name('RectArea Light Intensity');

rectAreaLightTweaks
    .add(rectAreaLight, 'width')
    .min(0)
    .max(5)
    .step(0.1)
    .name('Width');

rectAreaLightTweaks
    .add(rectAreaLight, 'height')
    .min(0)
    .max(5)
    .step(0.1)
    .name('Height');

// Spot light
const spotLight = new THREE.SpotLight(0x78ff00, 4.5, 10, Math.PI * 0.1, .25, 1);
spotLight.position.set(0, 2, 3);    
scene.add(spotLight);

spotLight.target.position.x = 1.5;
scene.add(spotLight.target); 

const spotLightTweaks = gui.addFolder('Spotlight'); 

spotLightTweaks
    .addColor(spotLight, 'color')
    .name('Spotlight Color');

spotLightTweaks
    .add(spotLight, 'intensity')
    .min(0)
    .max(10)
    .step(0.01)
    .name('Intensity');

spotLightTweaks
    .add(spotLight.target.position, 'x')
    .min(-2)
    .max(2)
    .step(0.01)
    .name('X');

spotLightTweaks
    .add(spotLight.target.position, 'y')
    .min(-2)
    .max(2)
    .step(0.01)
    .name('Y');

spotLightTweaks
    .add(spotLight, 'angle')
    .min(0)
    .max(Math.PI / 2)
    .step(Math.PI / 60)
    .name('Angle');

spotLightTweaks
    .add(spotLight, 'penumbra')
    .min(0)
    .max(1)
    .step(0.01)
    .name('Penumbra');

spotLightTweaks
    .add(spotLight, 'decay')
    .min(0)
    .max(5)
    .step(0.01)
    .name('Decay');

// Helpers
const hemisphereLightHelper = new THREE.HemisphereLightHelper(hemisphereLight, 0.2);
scene.add(hemisphereLightHelper);
hemiLightTweaks.onChange(() => {   
    hemisphereLightHelper.update();
});

const directionalLightHelper = new THREE.DirectionalLightHelper(directionalLight, 0.2);
scene.add(directionalLightHelper);
dirLightTweaks.onChange(() => {
    directionalLightHelper.update();
});

const pointLightHelper = new THREE.PointLightHelper(pointLight, 0.2);
scene.add(pointLightHelper);
pointLightTweaks.onChange(() => {
    pointLightHelper.update();
});

const rectAreaLightHelper = new RectAreaLightHelper(rectAreaLight);
scene.add(rectAreaLightHelper);

const spotLightHelper = new THREE.SpotLightHelper(spotLight);
scene.add(spotLightHelper);
spotLightTweaks.onChange(() => {
    spotLightHelper.update();
});

/**
 * Objects
 */
// Material
const material = new THREE.MeshStandardMaterial();
material.roughness = 0.4;

// Objects
const sphere = new THREE.Mesh(
    new THREE.SphereGeometry(0.5, 32, 32),
    material
);
sphere.position.x = - 1.5;

const cube = new THREE.Mesh(
    new THREE.BoxGeometry(0.75, 0.75, 0.75),
    material
);

const torus = new THREE.Mesh(
    new THREE.TorusGeometry(0.3, 0.2, 32, 64),
    material
);
torus.position.x = 1.5;

const plane = new THREE.Mesh(
    new THREE.PlaneGeometry(5, 5),
    material
);
plane.rotation.x = - Math.PI * 0.5;
plane.position.y = - 0.65;

scene.add(sphere, cube, torus, plane);

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
camera.position.x = 2;
camera.position.y = 2;
camera.position.z = 5;
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
const clock = new THREE.Clock();

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime();

    // Update objects
    sphere.rotation.y = 0.1 * elapsedTime;
    cube.rotation.y = 0.1 * elapsedTime;
    torus.rotation.y = 0.1 * elapsedTime;

    sphere.rotation.x = 0.15 * elapsedTime;
    cube.rotation.x = 0.15 * elapsedTime;
    torus.rotation.x = 0.15 * elapsedTime;

    // Update controls
    controls.update();

    // Render
    renderer.render(scene, camera);

    // Call tick again on the next frame
    window.requestAnimationFrame(tick);
};

tick();