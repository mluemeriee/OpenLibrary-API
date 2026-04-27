# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

# 1. Copy everything from your GitHub repo into the container
COPY . .

# 2. List the files (This helps us debug in the logs if it fails again)
RUN ls -R

# 3. Move into the SPECIFIC folder where your code lives
# If your GitHub repo has 'MobileApi' at the root, use this:
WORKDIR /source/MobileApi

# 4. Restore and Publish using the exact filename
RUN dotnet restore "MobileApi.csproj"
RUN dotnet publish "MobileApi.csproj" -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

ENTRYPOINT ["dotnet", "MobileApi.dll"]