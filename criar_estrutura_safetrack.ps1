# Caminho base
$base = "lib"

# Estrutura de diretórios
$dirs = @(
    "$base/core/theme",
    "$base/core/utils",
    "$base/core/services",
    "$base/data/models",
    "$base/data/providers",
    "$base/data/repositories",
    "$base/features/auth/pages",
    "$base/features/auth/controllers",
    "$base/features/tracking/pages",
    "$base/features/home/pages",
    "$base/shared/widgets",
    "$base/shared/helpers"
)

# Criar diretórios
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# Criar arquivos
$files = @(
    "$base/main.dart",
    "$base/app.dart",

    "$base/core/theme/app_theme.dart",
    "$base/core/utils/constants.dart",
    "$base/core/services/api_service.dart",

    "$base/data/models/user_model.dart",
    "$base/data/providers/auth_provider.dart",
    "$base/data/repositories/auth_repository.dart",

    "$base/features/auth/pages/login_page.dart",
    "$base/features/auth/pages/register_page.dart",
    "$base/features/auth/controllers/auth_controller.dart",

    "$base/features/tracking/pages/tracking_page.dart",
    "$base/features/home/pages/home_page.dart",

    "$base/shared/widgets/custom_button.dart",
    "$base/shared/widgets/custom_text_field.dart",
    "$base/shared/helpers/form_validators.dart"
)

foreach ($file in $files) {
    New-Item -ItemType File -Path $file -Force | Out-Null
}

Write-Host "✅ Estrutura do SafeTrack criada com sucesso!" -ForegroundColor Green
