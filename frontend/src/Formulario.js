import React, { useState } from 'react';
import './Formulario.css';

function Formulario() {
  const [titulo, setTitulo] = useState('');
  const [cuerpo, setCuerpo] = useState('');

  const handleSubmit = async (event) => {
    event.preventDefault();

      const response = await fetch('https://xrdfoxtcbg.execute-api.us-west-2.amazonaws.com/dev/items', {
        method: 'POST',
        body: JSON.stringify({
          title: titulo,  
          body: cuerpo,
        }),
      });
      if (response.ok) {
        alert('Datos enviados con éxito');
      } else {
        const errorData = await response.json(); // Assuming the server returns error details
        alert(`Error: ${errorData.message}`); // Display specific error message
      }
  };

  return (
    <form className="formulario" onSubmit={handleSubmit}>
      <label>
        Título:
        <input type="text" value={titulo} onChange={e => setTitulo(e.target.value)} />
      </label>
      <label>
        Cuerpo:
        <textarea value={cuerpo} onChange={e => setCuerpo(e.target.value)} />
      </label>
      <button type="submit">Enviar</button>
    </form>
  );
}

export default Formulario;