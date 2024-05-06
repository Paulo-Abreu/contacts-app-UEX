<template>
    <div>
      <h1>Contacts</h1>
  
      <ul>
        <li v-for="contact in contacts" :key="contact.id">
          {{ contact.name }} - {{ contact.phone }}
        </li>
      </ul>
  
      <h2>Add a New Contact</h2>
      <form @submit.prevent="createContact">
        <input v-model="name" type="text" placeholder="Name" required />
        <input v-model="address" type="text" placeholder="Address" required />
        <input v-model="zipcode" type="text" placeholder="ZIP Code" required />
        <input v-model="cpf" type="text" placeholder="CPF" required />
        <input v-model="phone" type="text" placeholder="Phone" required />
        <button type="submit">Add Contact</button>
      </form>
    </div>
  </template>
  
  <script>
  import axios from "axios";
  
  export default {
    data() {
      return {
        contacts: [],
        name: "",
        address: "",
        zipcode: "",
        cpf: "",
        phone: ""
      };
    },
    mounted() {
      this.fetchContacts();
    },
    methods: {
      fetchContacts() {
        axios.get("/contacts.json").then(response => {
          this.contacts = response.data;
        });
      },
      createContact() {
        axios
          .post("/contacts.json", {
            contact: {
              name: this.name,
              address: this.address,
              zipcode: this.zipcode,
              cpf: this.cpf,
              phone: this.phone
            }
          })
          .then(response => {
            this.contacts.push(response.data);
            this.name = "";
            this.address = "";
            this.zipcode = "";
            this.cpf = "";
            this.phone = "";
          });
      }
    }
  };
  </script>
  
  <style scoped>
  input {
    display: block;
    margin: 10px 0;
  }
  
  button {
    background-color: #007bff;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  button:hover {
    background-color: #0056b3;
  }
  </style>
  