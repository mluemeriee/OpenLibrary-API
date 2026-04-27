# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

# Copy everything
COPY . .

# This script finds the folder containing the .csproj and moves into it
RUN PROJECT_DIR=$(find . -name "*.csproj" -exec dirname {} \;) && \
    cd "$PROJECT_DIR" && \
    dotnet restore && \
    dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Matches the project name we saw in your screenshot
ENTRYPOINT ["dotnet", "MobileApi.dll"]