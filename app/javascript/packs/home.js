// app/javascript/packs/home.js
import { createApp } from 'vue';
import HomeComponent from '../components/Home.vue';

document.addEventListener('DOMContentLoaded', () => {
  createApp(HomeComponent).mount('#vue-home');
});
