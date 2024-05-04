<template>
  <div class="card">
    <h2>Login</h2>
    <form @submit.prevent="login">
      <input v-model="email" type="email" placeholder="Email" required :class="{'error': error}">
      <input v-model="password" type="password" placeholder="Password" required :class="{'error': error}">
      <button type="submit">Login</button>
    </form>
    <div v-if="error" class="error-message">Invalid login credentials</div>
    <div class="forgot-password">
      <a href="/users/password/new">Forgot Password?</a>
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
      error: false,
    };
  },
  methods: {
    login() {
      axios.post('/users/sign_in', {
        user: {
          email: this.email,
          password: this.password
        }
      })
      .then(response => {
        console.log('Success:', response);
        this.error = false;
        window.location.href = '/';
      })
      .catch(error => {
        console.error('Error:', error.response ? error.response.data : error.message);
        this.error = true;
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

input[type="email"].error, input[type="password"].error {
  border-color: #FF0000;
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

h2 {
  text-align: center;
  font-family: 'Arial', sans-serif;
}

.error-message {
  color: #FF0000;
  text-align: center;
  font-family: 'Arial', sans-serif;
}

.forgot-password {
  text-align: center;
  font-family: 'Arial', sans-serif;
}

.forgot-password a {
  color: #007BFF;
  text-decoration: none;
}
</style>
