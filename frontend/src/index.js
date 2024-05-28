import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import Formulario from './Formulario';
import reportWebVitals from './reportWebVitals';
import List from './List'; 

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
     <List />
  </React.StrictMode>
);

reportWebVitals();