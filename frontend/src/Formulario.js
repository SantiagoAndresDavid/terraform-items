import React, { useState } from 'react';
import './Formulario.css';

function Formulario() {
  const [titulo, setTitulo] = useState('');
  const [cuerpo, setCuerpo] = useState('');
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
          title: titulo,
          body: cuerpo,
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
        Título:
        <input type="text" value={titulo} onChange={e => setTitulo(e.target.value)} />
      </label>
      <label>
        Cuerpo:
        <textarea value={cuerpo} onChange={e => setCuerpo(e.target.value)} />
      </label>
      <label>
        Archivo:
        <input type="file" onChange={handleFileChange} />
      </label>
      <button type="submit">Enviar</button>
    </form>
  );
}

export default Formulario;
  