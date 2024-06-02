import React, { useState } from 'react';
import './Formulario.css';

function Formulario() {
  const [archivoBase64, setArchivoBase64] = useState('');
  const [archivoNombre, setArchivoNombre] = useState('');
  const [archivoTipo, setArchivoTipo] = useState('');

  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      setArchivoNombre(file.name);
      setArchivoTipo(file.type);
      const reader = new FileReader();
      reader.onloadend = () => {
        setArchivoBase64(reader.result.split(',')[1]); // Remueve el prefijo "data:<mime-type>;base64,"
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    try {
      const response = await fetch('https://2q4n6wtnse.execute-api.us-west-2.amazonaws.com/dev/items', {
        method: 'POST',
        body: JSON.stringify({
          file: archivoBase64,
          fileName: archivoNombre,
          fileType: archivoTipo,
        }),
      });

      if (response.ok) {
        alert('Datos enviados con éxito');
      } else {
        const errorData = await response.json();
        alert(`Error: ${errorData.message}`);
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  };

  return (
    <form className="formulario" onSubmit={handleSubmit}>
      <label>
        Archivo:
        <input type="file" onChange={handleFileChange} />
      </label>
      <button type="submit">Enviar</button>
    </form>
  );
}

export default Formulario;
  