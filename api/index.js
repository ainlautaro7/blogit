require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const PORT = 3000;

// Configuración de la base de datos
const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

// Middleware para parsear JSON
app.use(express.json());

//#region ARTICULO
app.post('/articles', async (req, res) => {
  const {
    userId,
    typeOf,
    title,
    description,
    coverImage,
    readablePublishDate,
    socialImage,
    tags,
    slug,
    path,
    url,
    canonicalUrl,
    commentsCount,
    positiveReactionsCount,
    publicReactionsCount,
    collectionId,
    createdAt,
    editedAt,
    crosspostedAt,
    publishedAt,
    lastCommentAt,
    publishedTimestamp,
    readingTimeMinutes,
    bodyHtml,
    bodyMarkdown,
    hide
  } = req.body;

  // Verificar si los campos son correctos
  const articleData = [
    userId || null,
    typeOf || null,
    title || null,
    description || null,
    coverImage || null,
    readablePublishDate || null,
    socialImage || null,
    tags ? JSON.stringify(tags) : null,  // Asegúrate de serializar los tags si es un array
    slug || null,
    path || null,
    url || null,
    canonicalUrl || null,
    commentsCount || 0,
    positiveReactionsCount || 0,
    publicReactionsCount || 0,
    collectionId || null,
    createdAt || null,
    editedAt || null,
    crosspostedAt || null,
    publishedAt || null,
    lastCommentAt || null,
    publishedTimestamp || null,
    readingTimeMinutes || 0,
    bodyHtml || null,
    bodyMarkdown || null,
    hide || 0,
  ];

  try {
    const connection = await mysql.createConnection(dbConfig);

    // Verificar que el número de parámetros coincida con los placeholders en la consulta
    const query = `INSERT INTO news_articles (user_id, type_of, title, description, cover_image, readable_publish_date, social_image, tags, slug, path, url, canonical_url, comments_count, positive_reactions_count, public_reactions_count, collection_id, created_at, edited_at, crossposted_at, published_at, last_comment_at, published_timestamp, reading_time_minutes, body_html, body_markdown,hide) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    console.log('Ejecutando consulta con parámetros:', articleData);  // Para depurar

    await connection.execute(query, articleData);

    res.status(201).send({ message: 'Artículo insertado exitosamente' });
  } catch (error) {
    console.error('Error al insertar el artículo:', error);
    res.status(500).send({ error: 'Error al insertar el artículo' });
  }
});
app.get('/articles', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const query = 'SELECT * FROM news_articles';
    const [articles] = await connection.execute(query);
    res.status(200).json({ articles });
  } catch (error) {
    console.error('Error al obtener artículos:', error);
    res.status(500).send({ error: 'Error al obtener artículos' });
  }
});
app.get('/articles/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const connection = await mysql.createConnection(dbConfig);
    const query = 'SELECT * FROM news_articles WHERE id = ?';
    const [article] = await connection.execute(query, [id]);

    if (article.length === 0) {
      return res.status(404).json({ message: 'Artículo no encontrado' });
    }

    res.status(200).json({ article: article[0] });
  } catch (error) {
    console.error('Error al obtener el artículo:', error);
    res.status(500).send({ error: 'Error al obtener el artículo' });
  }
});
app.put('/articles/:id', async (req, res) => {
  const articleId = req.params.id;
  const {
    userId,
    typeOf,
    title,
    description,
    coverImage,
    readablePublishDate,
    socialImage,
    tags,
    slug,
    path,
    url,
    canonicalUrl,
    commentsCount,
    positiveReactionsCount,
    publicReactionsCount,
    collectionId,
    createdAt,
    editedAt,
    crosspostedAt,
    publishedAt,
    lastCommentAt,
    publishedTimestamp,
    readingTimeMinutes,
    bodyHtml,
    bodyMarkdown,
    hide,
  } = req.body;

  // Conjunto de datos para actualizar, solo se actualizan los campos que se proporcionan
  const articleData = [
    userId || null,
    typeOf || null,
    title || null,
    description || null,
    coverImage || null,
    readablePublishDate || null,
    socialImage || null,
    tags || null,
    slug || null,
    path || null,
    url || null,
    canonicalUrl || null,
    commentsCount || 0,
    positiveReactionsCount || 0,
    publicReactionsCount || 0,
    collectionId || null,
    createdAt || null,
    editedAt || null,
    crosspostedAt || null,
    publishedAt || null,
    lastCommentAt || null,
    publishedTimestamp || null,
    readingTimeMinutes || 0,
    bodyHtml || null,
    bodyMarkdown || null,
    hide || 0,
  ];

  try {
    const connection = await mysql.createConnection(dbConfig);

    // Actualizar el artículo en la base de datos
    const query = `
      UPDATE news_articles
      SET 
        user_id = ?, type_of = ?, title = ?, description = ?, cover_image = ?, readable_publish_date = ?, 
        social_image = ?, tags = ?, slug = ?, path = ?, url = ?, canonical_url = ?, 
        comments_count = ?, positive_reactions_count = ?, public_reactions_count = ?, 
        collection_id = ?, created_at = ?, edited_at = ?, crossposted_at = ?, published_at = ?, 
        last_comment_at = ?, published_timestamp = ?, reading_time_minutes = ?, 
        body_html = ?, body_markdown = ?, hide = ?
      WHERE id = ?
    `;

    // Ejecución de la consulta
    await connection.execute(query, [...articleData, articleId]);

    res.status(200).send({ message: 'Artículo actualizado exitosamente' });
  } catch (error) {
    console.error('Error al actualizar el artículo:', error);
    res.status(500).send({ error: 'Error al actualizar el artículo' });
  }
});
app.delete('/articles/:id', async (req, res) => {
  const articleId = req.params.id;

  try {
    const connection = await mysql.createConnection(dbConfig);

    // Eliminar el artículo de la base de datos
    const query = 'DELETE FROM news_articles WHERE id = ?';

    // Ejecución de la consulta
    const [result] = await connection.execute(query, [articleId]);

    // Verificar si se eliminó algún artículo
    if (result.affectedRows === 0) {
      return res.status(404).send({ error: 'Artículo no encontrado' });
    }

    res.status(200).send({ message: 'Artículo eliminado exitosamente' });
  } catch (error) {
    console.error('Error al eliminar el artículo:', error);
    res.status(500).send({ error: 'Error al eliminar el artículo' });
  }
});

// Endpoint para obtener los artículos de un usuario
app.get('/articles/user/:userId', async (req, res) => {
  const { userId } = req.params;

  if (!userId) {
    return res.status(400).json({ error: true, message: 'El ID de usuario es obligatorio' });
  }

  const connection = await mysql.createConnection(dbConfig);

  try {
    const query = 'SELECT * FROM news_articles WHERE user_id = ?';
    const [rows] = await connection.execute(query, [userId]);

    if (rows.length === 0) {
      return res.status(404).json({ error: true, message: 'No se encontraron artículos para este usuario' });
    }

    res.status(200).json({
      error: false,
      articles: rows,
    });
  } catch (error) {
    console.error('Error al obtener los artículos del usuario:', error.message);
    res.status(500).json({ error: true, message: 'Error al obtener los artículos del usuario' });
  } finally {
    connection.end();
  }
});
//#endregion

//#region USUARIO
app.post('/users/register', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).send({ error: 'El campo usuario y contraseña son obligatorios' });
  }

  const connection = await mysql.createConnection(dbConfig);

  try {
    const query = `INSERT INTO users (username, password) VALUES (?, ?)`;
    await connection.execute(query, [username, password]);

    res.status(201).send({ message: 'Usuario registrado exitosamente' });
  } catch (error) {
    console.error('Error al registrar usuario:', error.message);
    res.status(500).send({ error: 'Error al registrar usuario' });
  } finally {
    connection.end();
  }
});

// Endpoint para inicio de sesión
app.post('/users/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: true, message: 'Faltan datos de usuario o contraseña' });
  }

  const connection = await mysql.createConnection(dbConfig);

  try {
    const query = 'SELECT * FROM users WHERE username = ?';
    const [rows] = await connection.execute(query, [username]);

    if (rows.length === 0) {
      return res.status(404).json({ error: true, message: 'Datos incorrectos' });
    }

    const user = rows[0];

    // Verificar contraseña
    if (user.password !== password) {
      return res.status(401).json({ error: true, message: 'Datos incorrectos' });
    }

    // Inicio de sesión exitoso
    res.status(200).json({
      error: false,
      message: 'Inicio de sesión exitoso',
      user: {
        id: user.id,
        username: user.username,
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        profilePhotoUrl: user.profile_photo_url,
        aboutMe: user.about_me,
      },
    });
  } catch (error) {
    console.error('Error en el inicio de sesión:', error);
    res.status(500).json({ error: true, message: 'Error en el servidor' });
  } finally {
    connection.end();
  }
});


app.post('/users/update', async (req, res) => {
  const { id, firstName, lastName, email, aboutMe } = req.body;

  if (!id) {
    return res.status(400).json({ error: true, message: 'El ID del usuario es obligatorio' });
  }

  const connection = await mysql.createConnection(dbConfig);

  try {
    const [rows] = await connection.execute('SELECT * FROM users WHERE id = ?', [id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: true, message: 'Usuario no encontrado' });
    }

    const user = rows[0]; // Primer (y único) resultado

    // Actualiza los campos
    user.first_name = firstName || user.first_name;
    user.last_name = lastName || user.last_name;
    user.email = email || user.email;
    user.about_me = aboutMe || user.about_me;

    // Realiza la actualización en la base de datos
    const updateQuery = `
      UPDATE users
      SET first_name = ?, last_name = ?, email = ?, about_me = ?
      WHERE id = ?
    `;
    await connection.execute(updateQuery, [user.first_name, user.last_name, user.email, user.about_me, id]);

    res.status(200).json({ error: false, message: 'Perfil actualizado con éxito' });
  } catch (error) {
    console.error('Error al actualizar el perfil:', error);
    res.status(500).json({ error: true, message: 'Error al actualizar el perfil' });
  } finally {
    connection.end();
  }
});

//#endregion

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
