import { createApp } from 'vue';
import ContactForm from '../components/ContactForm.vue';

document.addEventListener('DOMContentLoaded', () => {
  createApp(ContactForm).mount('#vue-contact-form');
});
