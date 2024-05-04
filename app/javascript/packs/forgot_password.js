// app/javascript/packs/forgot_password.js
import { createApp } from 'vue';
import ForgotPasswordComponent from '../components/ForgotPassword.vue';

document.addEventListener('DOMContentLoaded', () => {
  createApp(ForgotPasswordComponent).mount('#vue-forgot-password');
});
