import axios from "axios";

export const HTTP = axios.create({
  baseURL: process.env.BASE_API_URL || "http://localhost:4000/ajax"
});
