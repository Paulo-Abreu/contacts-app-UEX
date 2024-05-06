<template>
  <div class="contact-form">
    <h2>Criar Novo Contato</h2>
    <form @submit.prevent="createContact">
      <div class="form-group">
        <label for="name">Nome:</label>
        <input v-model="contact.name" type="text" id="name" required>
      </div>
      <div class="form-group">
        <label for="cep">CEP:</label>
        <input v-model="contact.zipcode" type="text" id="cep" ref="cepInput" @blur="fetchAddress" required>
      </div>
      <div class="form-group">
        <label for="address">Endereço:</label>
        <input v-model="contact.address" ref="addressInput" type="text" id="address" required>
      </div>
      <div class="form-group">
        <label for="cpf">CPF:</label>
        <input v-model="contact.cpf" type="text" id="cpf" ref="cpfInput" required>
      </div>
      <div class="form-group">
        <label for="country">País:</label>
        <select v-model="contact.country" @change="updatePhoneMask">
          <option v-for="country in countries" :key="country.name" :value="country">
            {{ country.name }}
          </option>
        </select>
      </div>
      <div class="form-group">
        <label for="phone">Telefone:</label>
        <input v-model="contact.phone" ref="phoneInput" type="text" id="phone" required>
      </div>
      <button type="submit" class="submit-button">Enviar</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import IMask from 'imask';

export default {
  data() {
    return {
      contact: {
        name: '',
        address: '',
        zipcode: '',
        cpf: '',
        phone: '',
        country: { name: 'Brazil', code: '+55' }
      },
      countries: [
        { name: 'Brazil', code: '+55', phoneMask: '(00) 00000-0000' },
        { name: 'United States', code: '+1', phoneMask: '(000) 000-0000' },
        { name: 'United Kingdom', code: '+44', phoneMask: '0000 000 0000' },
      ],
      phoneMaskInstance: null,
      cpfMaskInstance: null,
      cepMaskInstance: null,
      autocomplete: null,
    };
  },
  mounted() {
    this.updatePhoneMask();
    this.updateCpfMask();
    this.updateCepMask();
    this.loadGoogleMapsScript().then(() => {
      this.initializeAutocomplete();
    }).catch(error => {
      console.error('Erro ao carregar o script do Google Maps:', error);
    });
  },
  methods: {
    createContact() {
      // Obter o token CSRF
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

      // Enviar o formulário de contato
      axios.post('/contacts', { contact: this.contact })
        .then(response => {
          console.log('Contato criado com sucesso:', response);
          window.location = '/';
        })
        .catch(error => {
          console.error('Erro ao criar o contato:', error.response ? error.response.data : error.message);
        });
    },
    fetchAddress() {
      // Buscar o endereço baseado no CEP
      if (this.contact.zipcode.length === 9) {
        axios.get(`https://viacep.com.br/ws/${this.contact.zipcode.replace('-', '')}/json/`)
          .then(response => {
            if (!response.data.erro) {
              this.contact.address = `${response.data.logradouro}, ${response.data.bairro}, ${response.data.localidade} - ${response.data.uf}`;
            } else {
              console.error('CEP inválido');
            }
          })
          .catch(error => {
            console.error('Erro ao buscar o endereço:', error.response ? error.response.data : error.message);
          });
      }
    },
    updatePhoneMask() {
      // Atualizar a máscara do telefone
      const country = this.contact.country;
      const maskPattern = `${country.code} ${country.phoneMask}`;
      
      // Remover a máscara existente, se houver
      if (this.phoneMaskInstance) {
        this.phoneMaskInstance.destroy();
      }
      
      // Aplicar a nova máscara
      this.phoneMaskInstance = IMask(this.$refs.phoneInput, {
        mask: maskPattern
      });

      this.contact.phone = `${country.code} `;
    },
    updateCpfMask() {
      // Aplicar a máscara de CPF
      this.cpfMaskInstance = IMask(this.$refs.cpfInput, {
        mask: '000.000.000-00'
      });
    },
    updateCepMask() {
      // Aplicar a máscara de CEP
      this.cepMaskInstance = IMask(this.$refs.cepInput, {
        mask: '00000-000'
      });
    },
    loadGoogleMapsScript() {
      // Carregar o script do Google Maps
      return new Promise((resolve, reject) => {
        // Verificar se o script do Google Maps já está carregado
        if (window.google && window.google.maps && window.google.maps.places) {
          resolve();
          return;
        }

        // Criar um elemento script para o Google Maps
        const script = document.createElement('script');
        script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyCE_Xmd4KbP4qk_KXS_AQoXalFCKD2UEuo&libraries=places';
        script.async = true;
        script.defer = true;
        script.onload = () => resolve();
        script.onerror = (error) => reject(error);

        // Adicionar o script ao head do documento
        document.head.appendChild(script);
      });
    },
    initializeAutocomplete() {
      // Inicializar o Autocomplete do Google Maps
      const input = this.$refs.addressInput;
      this.autocomplete = new google.maps.places.Autocomplete(input);
      this.autocomplete.addListener('place_changed', this.onPlaceChanged);
    },
    onPlaceChanged() {
      // Atualizar o endereço com base no lugar selecionado
      const place = this.autocomplete.getPlace();
      if (place && place.formatted_address) {
        this.contact.address = place.formatted_address;
        
        // Extrair o código postal (CEP)
        for (const component of place.address_components) {
          if (component.types.includes("postal_code")) {
            this.contact.zipcode = component.long_name;
            break;
          }
        }
      }
    },
  }
}
</script>

<style scoped>
.contact-form {
  max-width: 400px;
  margin: 0 auto;
}

h2 {
  text-align: center;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.submit-button {
  width: 100%;
  background-color: #007bff;
  color: white;
  padding: 10px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.submit-button:hover {
  background-color: #0056b3;
}
</style>
