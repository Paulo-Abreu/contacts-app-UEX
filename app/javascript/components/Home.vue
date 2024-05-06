<template>
  <div class="container">
    <div class="contacts-container">
      <h1>Seus Contatos</h1>

      <!-- Barra de Pesquisa -->
      <input v-model="searchQuery" type="text" placeholder="Pesquisar por nome ou CPF" class="search-bar">

      <ul class="contact-list">
        <li v-for="contact in filteredContacts" :key="contact.id" class="contact-item">
          <div class="contact-info" @click="selectContact(contact)">
            <img :src="avatar" alt="Avatar" class="contact-avatar">
            <div class="contact-details">
              <span class="contact-name">{{ contact.name }}</span>
              <span class="contact-phone">{{ contact.phone }}</span>
            </div>
          </div>
          <button @click.stop="editContact(contact)" class="edit-button">Editar</button>
          <button @click.stop="deleteContact(contact)" class="delete-button">Excluir</button>
        </li>
      </ul>

      <div class="button-group">
        <button @click="logout" class="action-button logout-button">
          Sair
        </button>
        <button @click="goToNewContact" class="action-button add-button">
          Adicionar +
        </button>
        <button @click="deleteAccount" class="action-button delete-account-button">
          Excluir Conta
        </button>
      </div>
    </div>

    <div id="map" class="map-container"></div>
  </div>
</template>

<script>
import axios from 'axios';
import avatarImage from '../images/avatar.png'; // Ajustar o caminho conforme necessário

export default {
  data() {
    return {
      contacts: [],
      searchQuery: '',
      map: null,
      markers: [],
      bounds: new google.maps.LatLngBounds(),
      avatar: avatarImage
    };
  },
  computed: {
    filteredContacts() {
      return this.contacts.filter(contact => {
        return contact.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
               contact.cpf.includes(this.searchQuery);
      });
    }
  },
  mounted() {
    this.loadContacts();
    this.initMap();
  },
  methods: {
    loadContacts() {
      // Carregar os contatos
      axios.get('/contacts.json')
        .then(response => {
          this.contacts = response.data;
        })
        .catch(error => {
          console.error('Erro ao carregar contatos:', error.response ? error.response.data : error.message);
        });
    },
    initMap() {
      // Inicializar o mapa
      this.map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: -23.55052, lng: -46.633308 },
        zoom: 6,
      });
    },
    selectContact(contact) {
      // Usar o endereço completo, incluindo o número da casa
      const address = `${contact.address}, ${contact.zipcode}`;
      this.geocodeAddress(address);
    },
    geocodeAddress(address) {
      // Geocodificar o endereço
      const geocoder = new google.maps.Geocoder();
      geocoder.geocode({ address: address }, (results, status) => {
        if (status === "OK") {
          const position = results[0].geometry.location;
          const marker = new google.maps.Marker({
            map: this.map,
            position: position
          });
          this.markers.push(marker);

          // Ajustar os limites para incluir o novo marcador
          this.bounds.extend(position);
          this.map.fitBounds(this.bounds);

          // Ajustar o zoom
          if (this.markers.length === 1) {
            this.map.setZoom(this.map.getZoom() - 2);
          }
        } else {
          console.error("A geocodificação não foi bem-sucedida pelo seguinte motivo: " + status);
        }
      });
    },
    clearMarkers() {
      // Limpar os marcadores do mapa
      for (let marker of this.markers) {
        marker.setMap(null);
      }
      this.markers = [];
      this.bounds = new google.maps.LatLngBounds();
    },
    deleteContact(contact) {
      // Excluir um contato
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

      axios.delete(`/contacts/${contact.id}`)
        .then(response => {
          console.log('Contato excluído com sucesso:', response);
          this.loadContacts(); // Recarregar a lista de contatos
          this.clearMarkers(); // Limpar os marcadores do mapa
        })
        .catch(error => {
          console.error('Erro ao excluir contato:', error.response ? error.response.data : error.message);
        });
    },
    editContact(contact) {
      // Editar um contato
      window.location.href = `/contacts/${contact.id}/edit`;
    },
    logout() {
      // Fazer logout
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

      axios.delete('/users/sign_out')
        .then(response => {
          console.log('Logout realizado com sucesso:', response);
          window.location.href = '/users/sign_in';
        })
        .catch(error => {
          console.error('Erro durante o logout:', error.response ? error.response.data : error.message);
        });
    },
    goToNewContact() {
      // Navegar para a página de novo contato
      window.location.href = '/contacts/new';
    },
    deleteAccount() {
      // Excluir a conta do usuário
      const confirmDelete = confirm("Você tem certeza de que deseja excluir sua conta? Isso removerá todos os seus contatos e não pode ser desfeito.");
      if (!confirmDelete) return;

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

      axios.delete('/users')
        .then(response => {
          console.log('Conta excluída com sucesso:', response);
          window.location.href = '/users/sign_up';
        })
        .catch(error => {
          console.error('Erro ao excluir conta:', error.response ? error.response.data : error.message);
        });
    }
  }
}
</script>


<style scoped>
.container {
  display: flex;
  flex-direction: row;
  min-height: 100vh;
}

.contacts-container {
  display: flex;
  flex-direction: column;
  width: 30%;
  padding: 20px;
  overflow-y: auto;
}

.map-container {
  flex-grow: 1;
  height: 100vh;
}

h1 {
  text-align: left;
}
.search-bar {
  width: 100%;
  padding: 10px;
  margin-bottom: 20px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.contact-list {
  list-style: none;
  padding: 0;
  width: 100%;
  margin-bottom: 20px;
  border: 1px solid #ddd;
}

.contact-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #ddd;
}

.contact-info {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.contact-avatar {
  width: 50px;
  height: 50px;
  margin-right: 10px;
  border-radius: 50%;
}

.contact-details {
  display: flex;
  flex-direction: column;
  margin-left: 10px;
}

.contact-name {
  font-weight: bold;
  padding-bottom: 2px;
}

.contact-phone {
  color: #666;
  font-size: 1.2rem;
  white-space: nowrap;
}

.edit-button {
  background-color: transparent;
  border: none;
  color: blue;
  cursor: pointer;
  margin-left: 10px;
}

.delete-button {
  background-color: transparent;
  border: none;
  color: red;
  cursor: pointer;
  margin-left: 10px;
}

.button-group {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 40px;
  margin-top: auto;
}

.action-button {
  width: 80px;
  height: 80px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  text-align: center;
  font-size: 12px;
  padding: 5px;
}

.action-button:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.logout-button {
  background-color: #ff0000;
}

.logout-button:hover {
  background-color: #cc0000;
}

.add-button {
  background-color: #28a745;
}

.add-button:hover {
  background-color: #218838;
}
</style>

