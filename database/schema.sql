CREATE TABLE categorias (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE centros_consumo (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(50),
    ubicacion VARCHAR(150),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE productos (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_id BIGINT REFERENCES categorias(id),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    unidad_medida VARCHAR(20),
    costo_unitario NUMERIC(12,2),
    stock_minimo NUMERIC(12,2),
    stock_maximo NUMERIC(12,2),
    perecedero BOOLEAN DEFAULT FALSE,
    dias_caducidad INTEGER,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE ingredientes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id BIGINT REFERENCES productos(id),
    nombre VARCHAR(150),
    unidad_medida VARCHAR(20),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE recetas (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    rendimiento INTEGER,
    costo_total NUMERIC(12,2),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE receta_detalle (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    receta_id BIGINT REFERENCES recetas(id) ON DELETE CASCADE,
    ingrediente_id BIGINT REFERENCES ingredientes(id),
    cantidad NUMERIC(12,3),
    unidad_medida VARCHAR(20)
);

CREATE TABLE inventarios (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    producto_id BIGINT REFERENCES productos(id),
    existencia NUMERIC(12,2),
    stock_minimo NUMERIC(12,2),
    stock_maximo NUMERIC(12,2),
    ultima_actualizacion TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);



CREATE TABLE movimientos_inventario (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    inventario_id BIGINT REFERENCES inventarios(id),
    tipo_movimiento VARCHAR(30),
    cantidad NUMERIC(12,2),
    motivo TEXT,
    referencia VARCHAR(100),
    fecha TIMESTAMP DEFAULT NOW()
);

CREATE TABLE proveedores (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo VARCHAR(50),
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(50),
    correo VARCHAR(150),
    direccion TEXT,
    contacto VARCHAR(150),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE compras (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    proveedor_id BIGINT REFERENCES proveedores(id),
    fecha DATE,
    estado VARCHAR(30),
    total NUMERIC(14,2),
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE compra_detalle (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    compra_id BIGINT REFERENCES compras(id) ON DELETE CASCADE,
    producto_id BIGINT REFERENCES productos(id),
    cantidad NUMERIC(12,2),
    precio_unitario NUMERIC(12,2),
    subtotal NUMERIC(12,2)
);


CREATE TABLE produccion (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    receta_id BIGINT REFERENCES recetas(id),
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    fecha DATE,
    cantidad_programada NUMERIC(12,2),
    cantidad_producida NUMERIC(12,2),
    estado VARCHAR(30),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pronosticos (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id BIGINT REFERENCES productos(id),
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    fecha DATE,
    demanda_estimada NUMERIC(12,2),
    nivel_confianza NUMERIC(5,2),
    modelo_utilizado VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE reservaciones (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_reserva VARCHAR(50),
    fecha_llegada DATE,
    fecha_salida DATE,
    huespedes INTEGER,
    habitaciones INTEGER,
    ocupacion NUMERIC(5,2),
    origen VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE eventos (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    asistentes INTEGER,
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE alertas (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo VARCHAR(50),
    prioridad VARCHAR(20),
    mensaje TEXT,
    producto_id BIGINT REFERENCES productos(id),
    centro_consumo_id BIGINT REFERENCES centros_consumo(id),
    atendida BOOLEAN DEFAULT FALSE,
    fecha TIMESTAMP DEFAULT NOW()
);

CREATE TABLE conversaciones_ia (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id UUID,
    pregunta TEXT,
    respuesta TEXT,
    modelo VARCHAR(100),
    tokens INTEGER,
    fecha TIMESTAMP DEFAULT NOW()
);
