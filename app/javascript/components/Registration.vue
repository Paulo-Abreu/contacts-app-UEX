<template>
  <div class="card">
    <h2>Register</h2>
    <form @submit.prevent="register">
      <input v-model="email" type="email" placeholder="Email" required>
      <input v-model="password" type="password" placeholder="Password" required>
      <input v-model="passwordConfirmation" type="password" placeholder="Confirm Password" required>
      <button type="submit">Register</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      email: '',
      password: '',
      passwordConfirmation: ''
    };
  },
  methods: {
    register() {
      axios.post('/users', {
        user: {
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation
        }
      })
      .then(response => {
        console.log('Success:', response);
        // Lógica após registro bem-sucedido
      })
      .catch(error => {
        console.error('Error:', error.response ? error.response.data : error.message);
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

h2 {
  text-align: center;
  font-family: 'Arial', sans-serif;
}
</style>
