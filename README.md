# Sitio Web Estático – Automatizado con Terraform y GitHub Actions 🚀

## Descripción

Este proyecto despliega automáticamente un sitio web estático en Azure utilizando Terraform y GitHub Actions. Además, incluye un script backend personalizado que permite crear o destruir la infraestructura desde GitHub.

Actualmente estoy trabajando en implementar autenticación segura mediante OIDC.

---

## Tecnologías utilizadas

- Terraform (Infraestructura como Código)
- Azure Storage Static Website
- GitHub Actions (CI/CD)
- Bash Script (backend para control remoto)
- OIDC (en desarrollo)

---

## Workflows configurados

- `Terraform Apply`: despliega automáticamente toda la infraestructura al hacer push.
- `Terraform Destroy`: elimina la infraestructura desde GitHub (manual trigger).

---

## Cómo usarlo

1. Clona el repositorio.
2. Configura tus secretos en GitHub (ej: `ARM_CLIENT_ID`, `ARM_SUBSCRIPTION_ID`, etc.)
3. Ejecuta los workflows desde la pestaña "Actions".

---

## Gestión de imágenes estáticas

Las imágenes utilizadas en el sitio web se almacenan en **Azure Blob Storage**, y se referencian directamente en el HTML mediante la URL pública del blob.

Esto permite mantener el contenido multimedia separado del código fuente, facilitando actualizaciones y escalabilidad.

---

## Estado actual

✅ Infraestructura funcional  
✅ Despliegue automatizado  
⚙️ OIDC – en fase de integración  
