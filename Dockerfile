# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy everything
COPY . .

# DELETE any local bin/obj/dll files that might have been pushed
RUN rm -rf **/bin **/obj *.dll

# Build fresh
RUN dotnet restore
RUN dotnet publish -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

# Render's specific port requirements
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Ensure the name is exactly MobileApi.dll (case-sensitive)
ENTRYPOINT ["dotnet", "MobileApi.csproj"]