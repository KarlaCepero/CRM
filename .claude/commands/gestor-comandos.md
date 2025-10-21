# CRUD Comandos Claude - Gestión Dinámica de Comandos

Gestiona comandos personalizados de Claude Code mediante operaciones de Crear, Leer, Actualizar y Eliminar.

**Uso**: `/project:commands-manager <operación> <nombre-comando> [contenido]`

## Operaciones

### CREATE
Crea un nuevo comando de Claude a partir de instrucciones del usuario.

**Uso**: `/project:commands-manager create <nombre-comando> "descripción de lo que debe hacer el comando"`

**Ejemplo**:
```bash
/project:commands-manager create git-flow "Crear un comando que automatice las operaciones de git flow como crear ramas de características, PRs y fusiones"
```

### READ
Muestra el contenido de un comando de Claude existente.

**Uso**: `/project:commands-manager read <nombre-comando>`

**Ejemplo**:
```bash
/project:commands-manager read multi-mind
```

### UPDATE
Modifica un comando de Claude existente según las instrucciones del usuario.

**Uso**: `/project:commands-manager update <nombre-comando> "descripción de los cambios"`

**Ejemplo**:
```bash
/project:commands-manager update page "Añadir soporte para formato de exportación JSON e incluir marca temporal en los nombres de archivo"
```

### DELETE
Elimina un comando de Claude del sistema.

**Uso**: `/project:commands-manager delete <nombre-comando>`

**Ejemplo**:
```bash
/project:commands-manager delete old-command
```

### LIST
Muestra todos los comandos de Claude disponibles.

**Uso**: `/project:commands-manager list`

## Instrucciones de Implementación

**IMPORTANTE: Antes de ejecutar cualquier operación, consulta siempre la documentación oficial de comandos slash de Claude Code:**

1. Usa WebFetch para leer: `https://docs.claude.com/en/docs/claude-code/slash-commands`
2. Revisa la documentación para garantizar el cumplimiento de:
   - Requisitos de estructura y sintaxis de comandos
   - Opciones de frontmatter y metadatos
   - Patrones de marcadores de posición de argumentos (`$1`, `$2`, `$ARGUMENTS`)
   - Buenas prácticas para la creación de comandos
   - Configuraciones de permisos y herramientas

Ejecuta la operación CRUD solicitada:

### Para CREATE:
1. Analiza el nombre del comando y la descripción
2. Genera el contenido del comando apropiado basándose en la descripción
3. Crea el archivo de comando en `.claude/commands/{nombre-comando}.md`
4. Sigue la plantilla estándar de comando:
   ```markdown
   # Título del Comando


   Breve descripción del comando.

   **Uso**: `/project:{nombre-comando} $ARGUMENTS`

   ## Implementación

   [Instrucciones detalladas para Claude]

   ## Ejemplos

   [Ejemplos de uso]
   ```
5. Confirma la creación con la ruta del archivo

### Para READ:
1. Comprueba si el comando existe en `.claude/commands/{nombre-comando}.md`
2. Lee y muestra el contenido completo
3. Muestra ejemplos de uso si están presentes

### Para UPDATE:
1. Lee el contenido del comando existente
2. Aplica las modificaciones solicitadas según la descripción del usuario
3. Conserva la estructura del comando mientras actualizas la funcionalidad
4. Guarda el contenido actualizado
5. Muestra un resumen antes/después de los cambios

### Para DELETE:
1. Confirma que el comando existe
2. Muestra el contenido del comando como referencia
3. Elimina el archivo
4. Confirma la eliminación

### Para LIST:
1. Lista todos los archivos `.md` en `.claude/commands/`
2. Extrae y muestra:
    - Nombre del comando
    - Descripción breve (primer párrafo)
    - Sintaxis de uso

## Sincronización de Comandos

Después de cualquier operación CREATE, UPDATE o DELETE:

1. **Referencia al repositorio agent-guides**:
    - Repositorio: `https://github.com/tokenbender/agent-guides`
    - Directorio de comandos: `/claude-commands/`
    - Directorio de scripts: `/scripts/`

2. **Instrucciones de sincronización**:
    - Informar al usuario para sincronizar manualmente los cambios al repositorio agent-guides
    - Proporcionar el contenido del comando para copiar/pegar fácilmente
    - Sugerir crear un PR si es apropiado

3. **Ejemplos de referencia**:
    - Ver comandos existentes: https://github.com/tokenbender/agent-guides/tree/main/claude-commands
    - Script de extracción de sesión: https://github.com/tokenbender/agent-guides/blob/main/scripts/extract-claude-session.py
    - README del repositorio: https://github.com/tokenbender/agent-guides/blob/main/README.md

## Gestión de Errores

- **Comando no encontrado**: Sugerir comandos similares usando coincidencia difusa
- **Operación inválida**: Mostrar operaciones válidas (create, read, update, delete, list)
- **Errores de permisos**: Informar al usuario sobre problemas de acceso a archivos
- **Errores de Git**: Reportar pero no fallar la operación principal

## Criterios de Éxito

- Las operaciones de comandos se completan satisfactoriamente
- Los archivos están correctamente formateados y son funcionales
- Los cambios se sincronizan con agent-guides si está disponible
- El usuario recibe una confirmación clara de las acciones realizadas
- Los commits de Git son descriptivos y precisos

## Ejemplos de Comandos Generados

Al crear comandos, considera estos patrones:

1. **Comandos de análisis**: Como analyze-function, multi-mind
2. **Comandos de flujo de trabajo**: Como page, search-prompts
3. **Comandos de automatización**: Operaciones Git, pruebas, despliegue
4. **Comandos de documentación**: Generar documentación, actualizar READMEs

Asegúrate de que los comandos generados sean:
- Reutilizables entre proyectos
- Bien documentados con ejemplos
- Sigan patrones establecidos
- Incluyan gestión de errores
- Proporcionen salidas claras

Ejecuta ahora la operación CRUD solicitada.