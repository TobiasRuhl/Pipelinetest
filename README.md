# Pipelinetest
GitHub Actions Pipeline für den Trivy IaC Scanner

Für die automatische Prüfung der Terraform-/HCL-Dateien wird eine GitHub Actions Pipeline verwendet. Die Pipeline startet bei jedem Push oder Pull Request auf den main-Branch sowie manuell über workflow_dispatch.

Ziel der Pipeline ist es, Infrastructure-as-Code-Dateien im Repository mit Trivy auf Fehlkonfigurationen und Sicherheitsrisiken zu prüfen. Das Scan-Ergebnis wird im SARIF-Format gespeichert und anschließend in GitHub Security hochgeladen. Dadurch können die gefundenen Sicherheitsprobleme direkt im Repository unter den Security-Alerts angezeigt werden.

Erklärung der wichtigsten Bestandteile

Die Pipeline heißt trivy-iac-scan und wird automatisch ausgeführt, sobald Änderungen auf den main-Branch gepusht werden oder ein Pull Request gegen main erstellt wird. Zusätzlich kann sie manuell gestartet werden.

Der Job scan läuft auf einem GitHub-hosted Runner mit Ubuntu. Zuerst wird das Repository mit actions/checkout@v4 ausgecheckt, damit Trivy Zugriff auf die enthaltenen Terraform-/HCL-Dateien hat.

Danach wird Trivy über die offizielle GitHub Action aquasecurity/trivy-action@0.35.0 ausgeführt. Mit scan-type: config wird festgelegt, dass keine Container Images, sondern Infrastructure-as-Code-Konfigurationen gescannt werden. Über scan-ref: . wird das gesamte Repository geprüft.

Das Ergebnis wird mit format: sarif im SARIF-Format erzeugt und als Datei trivy-results.sarif gespeichert. SARIF ist ein standardisiertes Format, das GitHub zur Darstellung von Security Findings unterstützt.

Mit exit-code: 1 schlägt die Pipeline fehl, sobald Trivy Sicherheitsprobleme findet. Dadurch wird sichtbar, dass die aktuelle Infrastruktur-Konfiguration nicht den Sicherheitsanforderungen entspricht.

Im letzten Schritt wird die SARIF-Datei mit github/codeql-action/upload-sarif@v3 in GitHub Security hochgeladen. Durch if: always() wird dieser Schritt auch dann ausgeführt, wenn der Trivy Scan vorher fehlgeschlagen ist. So bleiben die Scan-Ergebnisse trotzdem verfügbar.
