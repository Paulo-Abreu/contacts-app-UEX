// app/javascript/packs/login.js
import { createApp } from 'vue';
import Login from '../components/Login.vue';

document.addEventListener('DOMContentLoaded', () => {
  createApp(Login).mount('#vue-login');
});
