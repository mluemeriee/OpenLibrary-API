# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy everything from your repo
COPY . .

# Force dotnet to find the project file wherever it is hidden
RUN dotnet restore $(find . -name "*.csproj" | head -n 1)
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

# Render's required port
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# This must match the name of your assembly (usually the name of the .csproj)
ENTRYPOINT ["dotnet", "MobileApi.dll"]