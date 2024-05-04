// Exemplo básico com hello_vue
import { createApp } from 'vue';
import App from '../app.vue';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App).mount('#app');
  document.body.appendChild(app.$el);
  console.log(app);
});