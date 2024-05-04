<!-- app/javascript/components/ForgotPassword.vue -->
<template>
    <div class="card">
      <h2>Forgot Password</h2>
      <form @submit.prevent="sendResetPasswordEmail">
        <input v-model="email" type="email" placeholder="Email" required>
        <button type="submit">Send Reset Instructions</button>
        <p v-if="error" class="error">{{ error }}</p>
        <p v-if="message" class="message">{{ message }}</p>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        email: '',
        error: '',
        message: ''
      };
    },
    methods: {
      sendResetPasswordEmail() {
        axios.post('/users/password', {
          user: {
            email: this.email
          }
        })
        .then(response => {
          this.message = response.data.message;
          this.error = '';
        })
        .catch(error => {
          this.error = error.response ? error.response.data.errors[0] : error.message;
          this.message = '';
        });
      }
    }
  };
  </script>
  
  <style scoped>
  .card {
    background: #f9f9f9;
    border-radius: 15px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 20px;
    width: 300px;
    margin: 40px auto;
  }
  
  input[type="email"] {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 20px;
    box-sizing: border-box;
  }
  
  button {
    width: 100%;
    background-color: #007BFF;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 20px;
    cursor: pointer;
  }
  
  button:hover {
    background-color: #0056b3;
  }
  
  .error {
    color: red;
    text-align: center;
  }
  
  .message {
    color: green;
    text-align: center;
  }
  
  h2 {
    text-align: center;
    font-family: 'Arial', sans-serif;
  }
  </style>
  