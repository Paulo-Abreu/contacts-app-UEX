import { createApp, h } from 'vue';
import EditContact from '../components/EditContact.vue';

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('edit-contact');
  const contactId = element.dataset.contactId;

  if (contactId) {
    const app = createApp({
      render() {
        return h(EditContact, { contactId: Number(contactId) });
      }
    });

    app.mount('#edit-contact');
  } else {
    console.error("No contact ID found in dataset.");
  }
});
