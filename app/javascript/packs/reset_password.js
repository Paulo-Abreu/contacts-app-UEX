// app/javascript/packs/reset_password.js
import { createApp } from 'vue';
import ResetPasswordComponent from '../components/ResetPassword.vue';

document.addEventListener('DOMContentLoaded', () => {
  createApp(ResetPasswordComponent).mount('#vue-reset-password');
});
