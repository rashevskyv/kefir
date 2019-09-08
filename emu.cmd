set sd=h


if exist "%sd%:\sxos\emunand" (
if not exist "%sd%:\sxos_" (mkdir %sd%:\sxos_\emunand)
move /Y %sd%:\sxos\emunand\* %sd%:\sxos_\emunand
if exist "%sd%:\sxos" (RD /s /q "%sd%:\sxos")
if not exist "%sd%:\sxos\" (mkdir %sd%:\sxos\emunand)
if exist "%sd%:\sxos_\emunand" (move /Y %sd%:\sxos_\emunand\* %sd%:\sxos\emunand)
if exist "%sd%:\sxos_" (RD /s /q "%sd%:\sxos_")
)