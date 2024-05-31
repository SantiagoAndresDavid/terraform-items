import React, { useState, useEffect } from 'react';
import './List.css'; // Importa los estilos CSS
import Formulario from './Formulario'; // Importa la clase Formulario

const List = () => {
    const [lista, setLista] = useState([]);
    const [mostrarFormulario, setMostrarFormulario] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const url = 'https://xrdfoxtcbg.execute-api.us-west-2.amazonaws.com/dev/items';
            try {
                const response = await fetch(url);
                if (!response.ok) {
                    throw new Error('Error en la solicitud');
                }
                const result = await response.json();
                const data = JSON.parse(result.body); // Parsear el string JSON contenido en `body`
                // No es necesario mapear `title.S` y `body.S` ya que los campos ya están correctos
                setLista(data);
            } catch (error) {
                setError('Error fetching data: ' + error.message);
                console.error('Error fetching data:', error);
            }
        };

        fetchData();
    }, []);

    const addItem = () => {
        setMostrarFormulario(true);
    };

    const handleNewItem = (newItem) => {
        setLista([...lista, newItem]);
        setMostrarFormulario(false);
    };

    if (mostrarFormulario) {
        return <Formulario setMostrarFormulario={setMostrarFormulario} onNewItem={handleNewItem} />;
    }

    return (
        <div>
            {error && <div className="error">{error}</div>}
            <table className="table">
                <thead>
                    <tr>
                        <th>Título</th>
                        <th>Cuerpo</th>
                    </tr>
                </thead>
                <tbody>
                    {lista.map((item, index) => (
                        <tr key={index}>
                            <td>{item.title}</td>
                            <td>{item.body}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
            <button onClick={addItem} className="button">Agregar Item</button>
        </div>
    );
};

export default List;
