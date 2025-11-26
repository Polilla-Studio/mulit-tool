#!/bin/bash

################################################################################
# CONFIGURACIÓN
################################################################################

# Ruta al repositorio maestro u October de Desarrollo
MASTER="$HOME/sites/moonsuite-dev-4/plugins/polillastudio"

# Destino: este proyecto (el script debe ejecutarse en la raíz del proyecto)
DEST="$PWD/plugins/polillastudio"

# Excepciones de rsync
EXCLUDES=(
    "--exclude=.git"
    "--exclude=vendor"
    "--exclude=node_modules"
    "--exclude=composer.lock"
)

################################################################################
# VALIDACIÓN DE PARÁMETROS
################################################################################

PLUGIN="$1"
DRYRUN="$2"

if [ -z "$PLUGIN" ]; then
    echo "Uso:"
    echo "  ./mulit nombre-plugin          (sync normal)"
    echo "  ./mulit nombre-plugin --dry    (solo mostrar cambios)"
    exit 1
fi

SOURCE="$MASTER/$PLUGIN/"
TARGET="$DEST/$PLUGIN/"

if [ ! -d "$SOURCE" ]; then
    echo "❌ El plugin '$PLUGIN' no existe en $MASTER"
    echo "Ruta buscada: $SOURCE"
    exit 1
fi

################################################################################
# LEER ÚLTIMO COMMIT DEL PLUGIN MAESTRO
################################################################################

if [ -d "$SOURCE/.git" ]; then
    COMMIT_HASH=$(git -C "$SOURCE" log -1 --pretty=format:"%h")
    COMMIT_MSG=$(git -C "$SOURCE" log -1 --pretty=format:"%s")
    COMMIT_DATE=$(git -C "$SOURCE" log -1 --pretty=format:"%ad" --date=short)
else
    COMMIT_HASH="N/A"
    COMMIT_MSG="No es un repo Git"
    COMMIT_DATE="N/A"
fi

################################################################################
# MOSTRAR INFO
################################################################################

echo "==============================================="
echo "      Actualización de Plugin October"
echo "==============================================="
echo "Plugin:        $PLUGIN"
echo "Origen:        $SOURCE"
echo "Destino:       $TARGET"
echo ""
echo "Último commit:"
echo "  Hash:        $COMMIT_HASH"
echo "  Mensaje:     $COMMIT_MSG"
echo "  Fecha:       $COMMIT_DATE"
echo ""

################################################################################
# EJECUCIÓN (DRY O REAL)
################################################################################

if [ "$DRYRUN" == "--dry" ]; then

    echo "🔎 DRY RUN — NO se aplicarán cambios"
    rsync -avn --delete "${EXCLUDES[@]}" "$SOURCE" "$TARGET"
    echo ""
    echo "✔ DRY RUN finalizado."
    exit 0

fi

################################################################################
# SINCRONIZACIÓN REAL
################################################################################

echo "🚀 Sincronizando..."
rsync -av --delete "${EXCLUDES[@]}" "$SOURCE" "$TARGET"

################################################################################
# GUARDAR MARCA DE AGUA
################################################################################

VERSION_FILE="$TARGET/.mulit-version"

echo "Guardando marca de agua en:"
echo "  $VERSION_FILE"

mkdir -p "$TARGET"

cat > "$VERSION_FILE" <<EOF
Plugin: $PLUGIN
Commit: $COMMIT_HASH
Mensaje: $COMMIT_MSG
Fecha: $COMMIT_DATE
Origen: $SOURCE
Actualizado: $(date "+%Y-%m-%d %H:%M:%S")
EOF

echo "✔ Sincronización completa."
echo "✔ Plugin '$PLUGIN' ahora está en commit $COMMIT_HASH"
