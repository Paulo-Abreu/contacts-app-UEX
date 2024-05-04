<!-- app/javascript/components/Home.vue -->
<template>
    <div>
      <button @click="logout" class="logout-button">Logout</button>
      <h1>Welcome to the Home Page!</h1>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    methods: {
      logout() {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        
        axios.delete('/users/sign_out')
          .then(response => {
            console.log('Logged out successfully:', response);
            // Redirecionar para a página de login
            window.location.href = '/users/sign_in';
          })
          .catch(error => {
            console.error('Error during logout:', error.response ? error.response.data : error.message);
          });
      }
    }
  }
  </script>
  
  <style scoped>
  .logout-button {
    position: absolute;
    top: 10px;
    right: 10px;
    padding: 10px 20px;
    background-color: #ff0000;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .logout-button:hover {
    background-color: #cc0000;
  }
  </style>
  