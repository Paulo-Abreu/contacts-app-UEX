<template>
    <div class="card">
      <h2>Forgot Password</h2>
      <form @submit.prevent="requestReset">
        <input v-model="email" type="email" placeholder="Email" required>
        <button type="submit">Send Reset Instructions</button>
      </form>
      <p v-if="error" class="error">{{ error }}</p>
      <p v-if="message" class="message">{{ message }}</p>
  
      <div v-if="token">
        <h2>Reset Password</h2>
        <form @submit.prevent="resetPassword">
          <input v-model="password" type="password" placeholder="New Password" required>
          <input v-model="passwordConfirmation" type="password" placeholder="Confirm Password" required>
          <button type="submit">Reset Password</button>
        </form>
        <p v-if="resetError" class="error">{{ resetError }}</p>
        <p v-if="resetMessage" class="message">{{ resetMessage }}</p>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        email: '',
        password: '',
        passwordConfirmation: '',
        token: '',
        error: '',
        message: '',
        resetError: '',
        resetMessage: ''
      };
    },
    methods: {
      requestReset() {
        axios.post('/users/password', {
          user: {
            email: this.email
          }
        })
        .then(response => {
          this.token = response.data.reset_password_token;
          this.error = '';
          this.message = 'Token generated successfully, please reset your password';
        })
        .catch(error => {
          this.error = error.response ? error.response.data.errors[0] : error.message;
          this.message = '';
        });
      },
      resetPassword() {
        axios.put('/users/password', {
          user: {
            reset_password_token: this.token,
            password: this.password,
            password_confirmation: this.passwordConfirmation
          }
        })
        .then(response => {
          this.resetError = '';
          this.resetMessage = 'Password reset successfully';
          window.location.href = response.data.redirect_url;  // Redirect to home page
        })
        .catch(error => {
          this.resetError = error.response ? error.response.data.errors[0] : error.message;
          this.resetMessage = '';
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
  
  input[type="email"], input[type="password"] {
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
  