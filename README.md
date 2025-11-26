# Mulit – Sincronizador de plugins para OctoberCMS

**Mulit** es un script Bash que permite sincronizar plugins desde un “repositorio maestro” hacia múltiples proyectos OctoberCMS de forma segura y controlada.  
Está pensado para equipos que mantienen varios proyectos y desean distribuir cambios sin hacer `git pull` dentro de cada proyecto.

---

## 🚀 Características

- **Sincronización unidireccional** desde un origen → destino(s)
- **Modo dry-run** para revisar los cambios antes de aplicarlos
- **Registro automático del último commit sincronizado**
- Excluye automáticamente archivos innecesarios (`.git`, `.DS_Store`, etc.)
- Evita modificar accidentalmente plugins directamente en los proyectos

---

## 📂 Estructura esperada

```
# Proyecto maestro (origen)
~/sites/master-proyect/plugins/<author>/<plugin-name>

# Proyectos destino (destino)
~/sites/awesome-proyect/plugins/<author>/<plugin-name>
~/sites/client-proyect/plugins/<author>/<plugin-name>
~/sites/another-proyect/plugins/<author>/<plugin-name>
```

---

## 📥 Uso

### 1. Descarga o clona este proyecto
- Descarga el script en la raiz de tu proyecto October Destino curl -s https://raw.githubusercontent.com/Polilla-Studio/mulit-tool/main/mulit.sh -o mulit.sh
- Dale permisos de ejecucion (chmod +x mulit.sh)

### 2. Ejecutar sincronización real
```bash
./mulit.sh nombreDelPlugin 
```

### 3. Revisar cambios sin aplicar (dry-run)
```bash
./mulit.sh nombreDelPlugin --dry
```

## 📝 Registro del commit sincronizado

Cada sincronización guarda un archivo .mulit-version dentro del plugin destino con:

- Último commit del origen
- Fecha de sincronización
- Ruta utilizada

Ejemplo:
```yaml
Plugin: mozaik
Commit: 12f3ae1
Mensaje: Metas SEO optimizados
Fecha: 2025-11-05
Origen: /Users/iec/sites/moonsuite-dev-4/plugins/polillastudio/mozaik/
Actualizado: 2025-11-26 00:52:13
```

Esto permite saber exactamente qué versión del plugin está instalada en cada proyecto.

## ⚠️ Requisitos
- macOS o Linux
- rsync
- Git instalado en el proyecto maestro

## 🤝 Contribuciones
Cualquier mejora es bienvenida.
Si este script te sirve, siéntete libre de clonarlo, modificarlo o compartirlo.
